#!/bin/bash

docker-machine create --driver amazonec2 \
    --amazonec2-ami "ami-0d359437d1756caa8" \
    --amazonec2-instance-type "g4dn.xlarge" \
    --amazonec2-iam-instance-profile "MLInstanceRole" \
    --amazonec2-region "eu-central-1" \
    --amazonec2-zone "a" \
    --amazonec2-root-size "64" \
    --amazonec2-vpc-id "vpc-01932bf2ad56de801" \
    --amazonec2-security-group "ml-sec-group"  \
    tobis-ml-machine

echo "Run eval $(docker-machine env tobis-ml-machine)"