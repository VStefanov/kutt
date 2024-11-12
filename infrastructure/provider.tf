provider "aws" {
  alias = "primary"
  region  = "eu-west-1"

  default_tags {
    tags = {
      Environment = "${var.environment}"
      Project     = "kutt-primary"
      Owner       = "deployment-admin"
    }
  }
}

provider "aws" {
  alias = "secondary"
  region  = "us-east-1"

  default_tags {
    tags = {
      Environment = "${var.environment}"
      Project     = "kutt-secondary"
      Owner       = "deployment-admin"
    }
  }
}