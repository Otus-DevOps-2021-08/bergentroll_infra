#! /usr/bin/env python3

import sys
import json


def read_file() -> dict:
    with open('./inventory.json', 'r') as inv_file:
        return json.loads(inv_file.read())


def search_node(obj: dict, name: str, result: list = None) -> list:
    if result is None:
        result = []

    if name in obj:
        result.append(obj[name])

    for val in obj.values():
        if isinstance(val, dict):
            search_node(val, name, result)

    return result


def make_list() -> dict:
    result = dict()
    for key, val in read_file().items():
        result[key] = search_node(val, 'ansible_host')
    return result


if __name__ == '__main__':
    arg = sys.argv[-1]
    if arg == '--load':
        print(json.dumps(make_list(), indent=2))
