# General settings
environment          = "dev"
resource_name_prefix = "myapp-kutt"

# Primary VPC settings (eu-west-1)
primary_public_subnet_count = 2
primary_app_subnet_count    = 2
primary_db_subnet_count     = 2
primary_vpc_cidr_block      = "10.0.0.0/16"
primary_public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
primary_app_subnet_cidrs    = ["10.0.3.0/24", "10.0.4.0/24"]
primary_db_subnet_cidrs     = ["10.0.5.0/24", "10.0.6.0/24"]
primary_azs                 = ["eu-west-1a","eu-west-1b"]

# Secondary VPC settings (us-east-1)
secondary_public_subnet_count = 2
secondary_app_subnet_count    = 2
secondary_db_subnet_count     = 2
secondary_vpc_cidr_block      = "10.1.0.0/16"
secondary_public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
secondary_app_subnet_cidrs    = ["10.1.3.0/24", "10.1.4.0/24"]
secondary_db_subnet_cidrs     = ["10.1.5.0/24", "10.1.6.0/24"]
secondary_azs                 = ["us-east-1a","us-east-1b"]

# ECR settings
ecr_replication_group_region_name = "us-east-1" # This is the SECONDARY region

# Aurora Global Database settings
db_engine         = "aurora-postgresql"
db_engine_version = "16.4"
database_name     = "kuttdb"
instance_class    = "db.r5.large"
master_username   = "temp_admin_user"
master_password   = "temp_admin_pass" # We have Aurora Global Database that does not support Secrets Manager password management out of the box.
db_port           = 5432

# Redis settings
node_type            = "cache.m6g.large"
num_cache_clusters   = 2
parameter_group_name = "default.redis6.x"
cache_engine         = "redis"
cache_engine_version = "6.x"
cache_cluster_port   = 6379


# Application settings
image_tag             = "latest"
app_domain_name       = "dev.some-domain.com" # TO BE UPDATED
app_health_check_path = "/api/v2/health"

# Route53
root_domain_name = "some-domain.com" # TO BE UPDATED
