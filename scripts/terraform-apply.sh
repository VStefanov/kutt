#!/bin/bash

ENVIRONMENT=$1

terraform apply -var-file=./environments/${ENVIRONMENT}.tfvars