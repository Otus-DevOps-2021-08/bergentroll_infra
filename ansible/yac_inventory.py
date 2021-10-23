#! /usr/bin/env python3

import argparse
import json
import configparser

import yandexcloud

from google.protobuf.json_format import MessageToDict
from yandex.cloud.compute.v1.instance_service_pb2 import ListInstancesRequest
from yandex.cloud.compute.v1.instance_service_pb2_grpc import InstanceServiceStub
from yandex.cloud.resourcemanager.v1.cloud_service_pb2 import ListCloudsRequest


def load_config() -> dict:
    parser = configparser.ConfigParser()
    parser.read('yac_inventory.conf')
    return dict(parser['general'])


def make_list(config: dict) -> dict:
    def _interface_switch(instance: dict, interface_type: str) -> str:
        if interface_type == 'internal':
            return (
                instance['networkInterfaces'][0]['primaryV4Address']
                ['address'])
        elif interface_type == 'external':
            return (
                instance['networkInterfaces'][0]['primaryV4Address']
                ['oneToOneNat']['address'])
        else:
            raise RuntimeError(f'Unknown interface type "{interface_type}"')

    with open(config.get('key_file', 'key.json'), 'r') as file:
        key = json.loads(file.read())

    sdk = yandexcloud.SDK(service_account_key=key)
    instance_service = sdk.client(InstanceServiceStub)

    resp = instance_service.List(
        ListInstancesRequest(folder_id=config['folder_id']))
    instances = MessageToDict(resp)['instances']

    app_hosts = []
    db_hosts = []

    for i in instances:
        name = i['name']
        if 'reddit-app' in name:
            app_hosts.append(i)
        elif 'reddit-db' in name:
            db_hosts.append(i)

    return {
        'db': [
            _interface_switch(i, config['db_hosts_interface'])
            for i in db_hosts
        ],
        'app': [
            _interface_switch(i, config['app_hosts_interface'])
            for i in app_hosts
        ],
    }


if __name__ == '__main__':
    INDENT_SIZE = 2

    parser = argparse.ArgumentParser()
    parser.add_argument('--list', action='store_true')
    parser.add_argument('--host')

    args = parser.parse_args()

    if args.list:
        config = load_config()
        print(json.dumps(make_list(config), indent=INDENT_SIZE))
    elif args.host:
        print(json.dumps({}, indent=INDENT_SIZE))
