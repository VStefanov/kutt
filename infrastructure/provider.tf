provider "aws" {
  region  = "eu-west-1"

  default_tags {
    tags = {
      Environment = "${var.environment}"
      Project     = "mbition-kutt"
      Owner       = "mbition-admin"
    }
  }
}