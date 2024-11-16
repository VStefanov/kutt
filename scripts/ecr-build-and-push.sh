#!/bin/bash

ENVIRONMENT=$1
ACCOUNT_ID=$2

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com

docker build -t kutt-${ENVIRONMENT} .

docker tag kutt-${ENVIRONMENT}:latest ${ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com/kutt-${ENVIRONMENT}:latest

docker push ${ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com/kutt-${ENVIRONMENT}:latest