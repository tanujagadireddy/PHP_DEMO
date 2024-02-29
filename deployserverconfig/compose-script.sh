#!/usr/bin/env bash

sudo DOCKER_PHP_IMAGE=$1 /usr/local/bin/docker-compose -f /home/ec2-user/deployserverconfig/docker-compose.yml up -d