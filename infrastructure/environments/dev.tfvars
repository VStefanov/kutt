# VPC settings
environment          = "dev"
resource_name_prefix = "mbition-kutt"
public_subnet_count  = 2
app_subnet_count     = 2
db_subnet_count      = 2
vpc_cidr_block       = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
app_subnet_cidrs     = ["10.0.3.0/24", "10.0.4.0/24"]
db_subnet_cidrs      = ["10.0.5.0/24", "10.0.6.0/24"]
azs                  = ["eu-west-1a","eu-west-1b"]

# Redis settings
node_type            = "cache.t3.micro"
num_cache_nodes      = 1
parameter_group_name = "default.redis7"
engine_version       = "7.1"

# Aurora PostgreSQL settings
database_name   = "kuttdb"
instance_class  = "db.t4g.medium"
master_username = "temp_admin_user"
master_password = "temp_admin_pass"

# Application settings
image_tag       = "latest"
app_domain_name = "dev.mbition-kutt.com"

# ALB settings
route53_hosted_zone_name = "mbition-kutt.com"