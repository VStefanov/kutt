#!/bin/bash

ENVIRONMENT=$1

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 504565868142.dkr.ecr.eu-west-1.amazonaws.com

docker build -t mbition-kutt-${ENVIRONMENT} .

docker tag mbition-kutt-${ENVIRONMENT}:latest 504565868142.dkr.ecr.eu-west-1.amazonaws.com/mbition-kutt-${ENVIRONMENT}:latest

docker push 504565868142.dkr.ecr.eu-west-1.amazonaws.com/mbition-kutt-${ENVIRONMENT}:latest