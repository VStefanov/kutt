ENVIRONMENT=$1

terraform plan -var-file=./environments/${ENVIRONMENT}.tfvars -target="module.ecr_global_cross_region"