#!/bin/bash

ENVIRONMENT=$1
ACCOUNT_ID=$2

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com

docker build -t myapp-kutt-repository-${ENVIRONMENT} .

docker tag myapp-kutt-repository-${ENVIRONMENT}:latest ${ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com/myapp-kutt-repository-${ENVIRONMENT}:latest

docker push ${ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com/myapp-kutt-repository-${ENVIRONMENT}:latest