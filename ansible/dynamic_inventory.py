#! /usr/bin/env python3

import argparse
import json


def read_file() -> dict:
    with open('./inventory.json', 'r') as inv_file:
        return json.loads(inv_file.read())


def search_node(obj: dict, name: str, result: list = None) -> list:
    if result is None:
        result = []

    val = obj.get(name)

    if val is not None:
        result.append(val)

    for val in obj.values():
        if isinstance(val, dict):
            search_node(val, name, result)

    return result


def make_list() -> dict:
    result = {}
    for key, val in read_file().items():
        result[key] = search_node(val, 'ansible_host')
    return result


def make_host(host: str) -> dict:
    result = {}

    for val in read_file().values():
        if host in val.get('hosts', {}).keys():
            # Group vars
            result.update(val.get('vars', {}))
            # Host vars
            result.update(val['hosts'][host])

    result.pop('ansible_host', None)

    return result


if __name__ == '__main__':
    indent_size = 2

    parser = argparse.ArgumentParser()
    parser.add_argument('--list', action='store_true')
    parser.add_argument('--host')

    args = parser.parse_args()

    if args.list:
        print(json.dumps(make_list(), indent=indent_size))
    elif args.host:
        print(json.dumps(make_host(args.host), indent=indent_size))
