#!/bin/bash

ENVIRONMENT=$1

terraform plan -var-file=./environments/${ENVIRONMENT}.tfvars