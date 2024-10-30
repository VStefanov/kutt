#!/bin/bash

ROLE_ARN=$1
SESSION_NAME=$2

ROLE_CREDENTIALS=$(aws sts assume-role --role-arn "$ROLE_ARN" --role-session-name "$SESSION_NAME")

export AWS_ACCESS_KEY_ID=$(echo $ROLE_CREDENTIALS | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $ROLE_CREDENTIALS | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $ROLE_CREDENTIALS | jq -r '.Credentials.SessionToken')

echo "AWS credentials successfully exported."
