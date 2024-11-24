# Network settings
module "vpc_primary" {
    source                  = "./modules/vpc"
    environment = var.environment
    vpc_cidr_block = var.primary_vpc_cidr_block
    public_subnet_count = var.primary_public_subnet_count
    app_subnet_count = var.primary_app_subnet_count
    db_subnet_count = var.primary_db_subnet_count
    public_subnet_cidrs = var.primary_public_subnet_cidrs
    app_subnet_cidrs = var.primary_app_subnet_cidrs
    db_subnet_cidrs = var.primary_db_subnet_cidrs
    azs = var.primary_azs

    db_port            = var.db_port
    cache_cluster_port = var.cache_cluster_port

    providers = {
      aws = aws.primary
    }
}

module "vpc_secondary" {
    source                  = "./modules/vpc"
    environment = var.environment
    vpc_cidr_block = var.secondary_vpc_cidr_block
    public_subnet_count = var.secondary_public_subnet_count
    app_subnet_count = var.secondary_app_subnet_count
    db_subnet_count = var.secondary_db_subnet_count
    public_subnet_cidrs = var.secondary_public_subnet_cidrs
    app_subnet_cidrs = var.secondary_app_subnet_cidrs
    db_subnet_cidrs = var.secondary_db_subnet_cidrs
    azs = var.secondary_azs

    db_port            = var.db_port
    cache_cluster_port = var.cache_cluster_port

    providers = {
      aws = aws.secondary
    }
}

# ECR Global Replication
module "ecr_global_cross_region" {
  source = "./modules/ecr-global"
  environment          = var.environment
  resource_name_prefix = "${var.resource_name_prefix}"

  create_replication_group             = true
  replication_group_region             = var.ecr_replication_group_region_name

  providers = {
      aws = aws.primary
    }
}

# Aurora Global Database
resource "aws_rds_global_cluster" "this" {
  provider                  = aws.primary
  global_cluster_identifier = "${var.resource_name_prefix}-global-cluster"
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  database_name             = var.database_name
}

module "db_primary" {
    source               = "./modules/aurora-global-cluster"
    environment          = var.environment
    resource_name_prefix = "${var.resource_name_prefix}-primary"

    master_password = var.master_password
    master_username = var.master_username
    instance_class  = var.instance_class
    database_name   = var.database_name
    engine          = var.db_engine
    engine_version  = var.db_engine_version
    port            = var.db_port

    azs             = var.primary_azs
    vpc_subnet_ids  = module.vpc_primary.db_subnet_ids
    security_groups = [module.vpc_primary.db_security_group_id]

    global_cluster_identifier = aws_rds_global_cluster.this.id
    cluster_instance_count    = 2

    providers = {
      aws = aws.primary
    }
}

module "db_secondary" {
    source               = "./modules/aurora-global-cluster"
    environment          = var.environment
    resource_name_prefix = "${var.resource_name_prefix}-secondary"
    instance_class  = var.instance_class
    engine          = var.db_engine
    engine_version  = var.db_engine_version
    port            = var.db_port

    azs             = var.secondary_azs
    vpc_subnet_ids  = module.vpc_secondary.db_subnet_ids
    security_groups = [module.vpc_secondary.db_security_group_id]

    global_cluster_identifier      = aws_rds_global_cluster.this.id
    enable_global_write_forwarding = true
    cluster_instance_count         = 1

    providers = {
      aws = aws.secondary
    }

    depends_on = [ 
      module.db_primary 
    ]
}

# ElastiCache Global Datastore
module "cache_primary" {
    source               = "./modules/elasticache-global-datastore"
    environment          = var.environment
    resource_name_prefix = "${var.resource_name_prefix}-primary"

    create_primary_global_replication_group = true

    node_type            = var.node_type
    parameter_group_name = var.parameter_group_name
    engine               = var.cache_engine
    engine_version       = var.cache_engine_version
    num_cache_clusters   = var.num_cache_clusters
    port                 = var.cache_cluster_port

    vpc_subnet_ids  = module.vpc_primary.app_subnet_ids
    security_groups = [module.vpc_primary.cache_security_group_id]
    azs             = var.primary_azs

    providers = {
      aws = aws.primary
    }
}

module "cache_secondary" {
    source               = "./modules/elasticache-global-datastore"
    environment          = var.environment
    resource_name_prefix = "${var.resource_name_prefix}-secondary"

    create_secondary_global_replication_group = true
    global_replication_group_id               = module.cache_primary.global_replication_group_id

    node_type            = var.node_type
    parameter_group_name = var.parameter_group_name
    engine               = var.cache_engine
    engine_version       = var.cache_engine_version
    num_cache_clusters   = var.num_cache_clusters
    port                 = var.cache_cluster_port

    vpc_subnet_ids  = module.vpc_secondary.app_subnet_ids
    security_groups = [module.vpc_secondary.cache_security_group_id]
    azs             = var.secondary_azs

    providers = {
      aws = aws.secondary
    }

    depends_on = [ 
      module.cache_primary
     ]
}

# ALB
module "alb_primary" {
    source               = "./modules/alb"
    environment          = var.environment
    resource_name_prefix = "${var.resource_name_prefix}-primary"
    
    vpc_id = module.vpc_primary.vpc_id
    vpc_subnet_ids = module.vpc_primary.public_subnet_ids
    security_groups = [module.vpc_primary.alb_security_group_id]

    health_check_path = var.app_health_check_path

    providers = {
      aws = aws.primary
    }
}

module "alb_secondary" {
    source               = "./modules/alb"
    environment          = var.environment
    resource_name_prefix = "${var.resource_name_prefix}-secondary"
    
    vpc_id = module.vpc_secondary.vpc_id
    vpc_subnet_ids = module.vpc_secondary.public_subnet_ids
    security_groups = [module.vpc_secondary.alb_security_group_id]

    providers = {
      aws = aws.secondary
    }
}


# Bastion Hosts
module "bastion_db_primary" {
  source               = "./modules/bastion-host-ssm"
  environment          = var.environment
  resource_name_prefix = "${var.resource_name_prefix}-db-primary"

  subnet_id       = module.vpc_primary.db_subnet_ids[0]
  security_groups = [module.vpc_primary.bastion_security_group_id]
}

module "bastion_cache_primary" {
  source               = "./modules/bastion-host-ssm"
  environment          = var.environment
  resource_name_prefix = "${var.resource_name_prefix}-cache-primary"

  subnet_id       = module.vpc_primary.app_subnet_ids[0]
  security_groups = [module.vpc_primary.bastion_security_group_id]
}

# Application
module "app_primary" {
    source = "./modules/ecs-fargate-app"
    environment          = var.environment
    resource_name_prefix = "${var.resource_name_prefix}-primary"

    container_environment_variables = [
        { name = "DB_HOST", value = "${module.db_primary.writer_endpoint}" },
        { name = "DB_PORT", value = "${var.db_port}" },
        { name = "DB_NAME", value = "${var.database_name}" },
        { name = "DB_USER", value = "${var.master_username}" },
        { name = "DB_PASSWORD", value = "${var.master_password}"},
        { name = "DB_SSL", value = "false" },
        { name = "DEFAULT_DOMAIN", value = "${module.alb_primary.domain_name}" },
        { name = "REDIS_HOST", value = "${module.cache_primary.replication_group_primary_endpoint_address}" },
        { name = "REDIS_PORT", value = "${var.cache_cluster_port}" },
        { name = "REDIS_PASSWORD", value = "" }
    ]

    alb_target_group_arn = module.alb_primary.target_group_arn
    desired_count        = 1
    
    memory = 512
    cpu = 256
    container_port = 3000
    host_port = 3000
    image = "${module.ecr_global_cross_region.repository_url}:${var.image_tag}"

    azs             = var.primary_azs
    vpc_subnet_ids  = module.vpc_primary.app_subnet_ids
    security_groups = [module.vpc_primary.app_security_group_id]

    providers = {
      aws = aws.primary
    }
}


module "app_secondary" {
    source = "./modules/ecs-fargate-app"
    environment          = var.environment
    resource_name_prefix = "${var.resource_name_prefix}-secondary"

    alb_target_group_arn = module.alb_secondary.target_group_arn

    create_task_definition = false # We want an empty Service for the Pilot Light backup strategy
    desired_count          = 0
    
    azs             = var.secondary_azs
    vpc_subnet_ids  = module.vpc_secondary.app_subnet_ids
    security_groups = [module.vpc_secondary.app_security_group_id]

    providers = {
      aws = aws.secondary
    }
}

# Route53
module "route_primary" {
  source = "./modules/route53-failover"

  alb_dns     = module.alb_primary.domain_name
  alb_zone_id = module.alb_primary.zone_id
  
  health_check_resource_path = var.app_health_check_path
  health_port                = 80
  failover_policy_type       = "PRIMARY"
  record_identifier          = "primary"
  

  hosted_zone_id = data.aws_route53_zone.this.zone_id
  domain_name    = var.app_domain_name
}

module "route_secondary" {
  source = "./modules/route53-failover"

  alb_dns     = module.alb_secondary.domain_name
  alb_zone_id = module.alb_secondary.zone_id

  
  health_check_resource_path = var.app_health_check_path
  health_port                = 80
  failover_policy_type       = "SECONDARY"
  record_identifier          = "secondary"


  hosted_zone_id = data.aws_route53_zone.this.zone_id
  domain_name    = var.app_domain_name
}
