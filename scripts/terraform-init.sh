BUCKET_NAME=$1

terraform init -backend-config="bucket=${BUCKET_NAME}"