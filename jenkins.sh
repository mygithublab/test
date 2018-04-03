#!/bin/bash

docker build -t test .
docker rm -f test
docker run -itd --name test -p 5001:22 -p 5000:80 -v /volume:/share test
