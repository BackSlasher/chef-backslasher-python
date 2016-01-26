#!/usr/bin/env bats

@test "virtualenv test environment should exist" {
     [ -f "/tmp/kitchen/cache/virtualenv/bin/activate" ]
}

@test "virtualenv test environment should be owned by root" {
    ls -l /tmp/kitchen/cache/virtualenv | grep "root root"
}

@test "virtualenv test environment should have boto working" {
    /tmp/kitchen/cache/virtualenv/bin/python -c 'import boto; boto.Version'
}
