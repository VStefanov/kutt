
module "vpc" {
    source                  = "./modules/vpc"
    environment = var.environment
    vpc_cidr_block = var.vpc_cidr_block
    public_subnet_count = 2
    app_subnet_count = 2
    db_subnet_count = 2
    public_subnet_cidrs = var.public_subnet_cidrs
    app_subnet_cidrs = var.app_subnet_cidrs
    db_subnet_cidrs = var.db_subnet_cidrs
    azs = var.azs
}

module "redis" {
    source               = "./modules/elasticache-redis"
    environment          = var.environment
    resource_name_prefix = var.resource_name_prefix

    node_type            = var.node_type
    parameter_group_name = var.parameter_group_name
    engine_version       = var.engine_version
    num_cache_nodes      = var.num_cache_nodes

    vpc_subnet_ids       = module.vpc.app_subnet_ids
    security_groups      = [module.vpc.cache_security_group_id]
}

module "db" {
    source               = "./modules/aurora-postgresql"
    environment          = var.environment
    resource_name_prefix = var.resource_name_prefix

    master_password      = var.master_password
    master_username      = var.master_username
    instance_class       = var.instance_class
    database_name        = var.database_name

    azs                  = var.azs
    vpc_subnet_ids       = module.vpc.db_subnet_ids
    security_groups      = [module.vpc.db_security_group_id]
}

module "app" {
    source = "./modules/ecs-fargate-app"
    environment          = var.environment
    resource_name_prefix = var.resource_name_prefix

    db_host = module.db.db_host
    db_name = var.database_name
    db_pass = var.master_password
    db_user = var.master_username

    redis_host = module.redis.redis_host
    
    alb_target_group_arn = module.alb.target_group_arn
    app_domain_name = module.alb.domain_name

    memory = 512
    cpu = 256
    container_port = 3000
    host_port = 3000
    image = "${data.aws_ecr_repository.this.repository_url}:${var.image_tag}"

    azs             = var.azs
    vpc_subnet_ids  = module.vpc.app_subnet_ids
    security_groups = [module.vpc.app_security_group_id]
}

module "alb" {
    source               = "./modules/alb"
    environment          = var.environment
    resource_name_prefix = var.resource_name_prefix

    vpc_id = module.vpc.vpc_id
    vpc_subnet_ids = module.vpc.public_subnet_ids
    security_groups = [module.vpc.alb_security_group_id]
}

