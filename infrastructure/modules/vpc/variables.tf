variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
}

variable "app_subnet_count" {
  description = "Number of app private subnets"
  type        = number
}


variable "db_subnet_count" {
  description = "Number of db private subnets"
  type        = number
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for app private subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for db private subnets"
  type        = list(string)
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}
