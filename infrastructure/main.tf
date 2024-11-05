
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

    container_environment_variables = [
        { name = "DB_HOST", value = "${module.db.db_host}" },
        { name = "DB_PORT", value = "5432" },
        { name = "DB_NAME", value = "${var.database_name}" },
        { name = "DB_USER", value = "${var.master_username}" },
        { name = "DB_PASSWORD", value = "${var.master_password}"},
        { name = "DB_SSL", value = "false" },
        { name = "DEFAULT_DOMAIN", value = "${var.app_domain_name}" },
        { name = "REDIS_HOST", value = "${module.redis.redis_host}" },
        { name = "REDIS_PORT", value = "6379" },
        { name = "REDIS_PASSWORD", value = "" }
    ]

    alb_target_group_arn = module.alb.target_group_arn
    
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
    
    route53_hosted_zone_name = var.route53_hosted_zone_name

    vpc_id = module.vpc.vpc_id
    vpc_subnet_ids = module.vpc.public_subnet_ids
    security_groups = [module.vpc.alb_security_group_id]
}

