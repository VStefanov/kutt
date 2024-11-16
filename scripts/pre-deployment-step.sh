#!/bin/bash


# ===========================================
# Manual steps before PRE-DEPLOYMENT script:
#  - Registering domain name
#  - Issuing certificate and validating it for the DEV env
# ===========================================

# ===========================================
# Logic for creating ECR
# ===========================================

ENVIRONMENT=$1

REPO_NAME="kutt-${ENVIRONMENT}"
AWS_REGION="eu-west-1"

# Check if repository already exists
REPO_EXISTS=$(aws ecr describe-repositories --repository-names "$REPO_NAME" --region "$AWS_REGION" --query 'repositories[*].repositoryName' --output text 2>/dev/null)

if [ "$REPO_EXISTS" == "$REPO_NAME" ]; then
  echo "ECR repository '$REPO_NAME' already exists."
else
  aws ecr create-repository --repository-name "$REPO_NAME" --region "$AWS_REGION"
  
  if [ $? -eq 0 ]; then
    echo "ECR repository '$REPO_NAME' created successfully."
  else
    echo "Failed to create ECR repository '$REPO_NAME'."
  fi
fi
