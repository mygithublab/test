#!/bin/bash

set -e

DOCKER_IMAGE_NAME=test
DOCKER_CONTAINER_NAME=testcontainer

bash prerequisite-firsttime.sh

docker build -t "${DOCKER_IMAGE_NAME}" .

docker images

docker run -itd --name "${DOCKER_CONTAINER_NAME}" -p 10086:80 -p 10087:22 -v $WORKSPACE/etc:/usr/local/nagios/etc -v /github/test/nagios/var:/usr/local/nagios/var -v /github/test/nagiosgraph/var:/usr/local/nagiosgraph/var -v /test:/share -t --restart=always "${DOCKER_IMAGE_NAME}"

docker ps -a
