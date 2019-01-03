#!/bin/bash

set -e

DOCKER_IMAGE_NAME=test
DOCKER_CONTAINER_NAME=testcontainer

docker build -t "${DOCKER_IMAGE_NAME}" .

docker images

docker run -itd --name "${DOCKER_CONTAINER_NAME}" -p 10086:80 -t "${DOCKER_IMAGE_NAME}"

docker ps -a
