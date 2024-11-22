ENVIRONMENT=$1

terraform apply -var-file=./environments/${ENVIRONMENT}.tfvars -target="module.ecr_primary" -target="module.ecr_secondary"