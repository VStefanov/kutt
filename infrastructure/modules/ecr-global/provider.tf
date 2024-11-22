provider "aws" {
  alias  = "source"
  region = var.source_ecr_region
}