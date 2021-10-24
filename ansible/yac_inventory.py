#! /usr/bin/env python3

import argparse
import copy
import json
import logging
import typing as T

import yaml
import yandexcloud

from google.protobuf.json_format import MessageToDict
from yandex.cloud.compute.v1.instance_service_pb2 import ListInstancesRequest
from yandex.cloud.compute.v1.instance_service_pb2_grpc import InstanceServiceStub


class ListComposer():
    class ConfigError(RuntimeError):
        ...

    class ListComposerError(RuntimeError):
        ...

    _config_template: dict = {
        'general': {
            'folder_id': None,
            'key_file': None,
            'jump_host': None,
            'jump_host_user': None,
        },
        'groups': [],
    }

    _group_obligatory_fields = {'name', 'match', 'internal_interface'}

    def __init__(self):
        self._logger = logging.getLogger(__name__)
        self._config = copy.deepcopy(self._config_template)
        self._instances = []

        self.deep_update(self._config, self._load_config())
        self._logger.debug(f'Config is {self._config}')
        self._validate_config()

    @staticmethod
    def deep_update(dst_dict: dict, src_dict: dict) -> dict:
        for key, val in src_dict.items():
            if isinstance(val, dict):
                dst_dict[key] = ListComposer.deep_update(dst_dict.get(key, {}), val)
            else:
                dst_dict[key] = val

        return dst_dict

    @staticmethod
    def _load_config() -> dict:
        with open('yac_inventory_conf.yml', 'r') as file:
            return yaml.safe_load(file.read())

    def _validate_config(self) -> None:
        for group in self._config['groups']:
            keys = set(group)
            diff = self._group_obligatory_fields.difference(keys)
            if len(diff) > 0:
                raise ListComposer.ConfigError(f'Obligatory fields [{", ".join(diff)}] is missing for a group')

        grp_with_internal = [g['name'] for g in self._config['groups'] if g['internal_interface']]
        if self._config['general']['jump_host'] is None and len(grp_with_internal) > 0:
            raise ListComposer.ConfigError(
                f'Jump host is required by groups [{", ".join(grp_with_internal)}], but is not specified')

    def _set_instance_list_from_remote(self) -> None:
        conf_general = self._config['general']

        with open(conf_general['key_file'], 'r') as file:
            key = json.loads(file.read())

        sdk = yandexcloud.SDK(service_account_key=key)
        instance_service = sdk.client(InstanceServiceStub)

        resp = instance_service.List(
            ListInstancesRequest(folder_id=conf_general['folder_id']))
        self._instances = MessageToDict(resp)['instances']

    @staticmethod
    def _get_ipv4(instance: dict, is_internal: bool) -> str:
        if is_internal:
            return instance['networkInterfaces'][0]['primaryV4Address']['address']
        return instance['networkInterfaces'][0]['primaryV4Address']['oneToOneNat']['address']

    def _get_jump_host_string(self) -> str:
        conf_jump_host = self._config['general']['jump_host']

        if conf_jump_host:
            jump_host = self._find_instance(conf_jump_host)
            if jump_host is None:
                raise ListComposer.ListComposerError(f'Jump host {conf_jump_host} not found')
            logging.debug(f'Found jump host {jump_host}')

        jump_host_ip = self._get_ipv4(jump_host, is_internal=False)
        jump_host_user = self._config['general']['jump_host_user']

        if jump_host_user:
            return f'{jump_host_user}@{jump_host_ip}'

        return jump_host_ip

    def _find_instance(self, name: str) -> T.Optional[T.Dict[str, T.Any]]:
        for i in self._instances:
            if i['name'] == name:
                return i
        return None

    def get_list(self) -> dict:
        self._set_instance_list_from_remote()

        grouped_hosts: T.Dict[str, T.Dict] = {
            g['name']: {'internal_interface': g['internal_interface'], 'hosts': []}
            for g in self._config['groups']}

        for i in self._instances:
            for group in self._config['groups']:
                if group['match'] in i['name']:
                    grouped_hosts[group['name']]['hosts'].append(self._get_ipv4(i, group['internal_interface']))

        result: T.Dict[str, T.Dict] = {
            '_meta': {
                'hostvars': {},
            },
        }

        for group_name, val in grouped_hosts.items():
            result[group_name] = {
                'hosts': val['hosts'],
                'vars': {},
            }

            if val['internal_interface']:
                result[group_name]['vars']['ansible_ssh_common_args'] = f'-J {self._get_jump_host_string()}'

        return result


if __name__ == '__main__':
    INDENT_SIZE = 2
    LOGGING_LEVEL = logging.ERROR

    logging.basicConfig()
    logging.getLogger().setLevel(LOGGING_LEVEL)

    parser = argparse.ArgumentParser()
    parser.add_argument('--list', action='store_true')
    parser.add_argument('--host')

    args = parser.parse_args()

    if args.list:
        composer = ListComposer()
        print(json.dumps(composer.get_list(), indent=INDENT_SIZE))
    elif args.host:
        print(json.dumps({}, indent=INDENT_SIZE))
