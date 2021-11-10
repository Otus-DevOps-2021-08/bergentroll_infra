import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_mongo_running_and_enabled(host):
    ''' MongoDB is enabled and running '''
    mongo = host.service("mongod")
    assert mongo.is_running
    assert mongo.is_enabled


def test_config_file(host):
    ''' Configuration file contains the required line '''
    config_file = host.file('/etc/mongod.conf')
    assert config_file.contains('bindIp: 0.0.0.0')
    assert config_file.is_file


def test_socket_is_binded(host):
    ''' Port is listened '''
    assert host.socket('tcp://0.0.0.0:27017').is_listening
