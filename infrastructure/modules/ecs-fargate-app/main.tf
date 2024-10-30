resource "aws_ecs_cluster" "cluster" {
  name = "${var.resource_name_prefix}-cluster-${var.environment}"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.resource_name_prefix}-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  memory                   = var.memory
  cpu                      = var.cpu

  container_definitions = jsonencode([{
    name  = "${var.resource_name_prefix}-app-${var.environment}"
    image = var.image
    essential = true
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.host_port
    }]
    logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    environment = [
      {
        name  = "DB_HOST"
        value = "${var.db_host}"
      },
      {
        name = "DB_PORT"
        value = "${var.db_port}"
      },
      {
        name = "DEFAULT_DOMAIN"
        value = "${var.app_domain_name}" # Should be set to LB
      },
      {
        name = "DB_NAME"
        value = "${var.db_name}"
      },
      {
        name = "DB_USER"
        value = "${var.db_user}"
      },
      {
        name = "DB_PASSWORD"
        value = "${var.db_pass}"
      },
      {
        name = "DB_SSL"
        value = "false"
      },
      {
        name  = "REDIS_HOST"
        value = "${var.redis_host}"
      },
      {
        name  = "REDIS_PORT"
        value = "${var.redis_port}"
      },
      {
        name  = "REDIS_PASSWORD"
        value = "${var.redis_password}"
      }
    ]
  }])
}

resource "aws_ecs_service" "service" {
  name            = "${var.resource_name_prefix}-service-${var.environment}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.vpc_subnet_ids
    security_groups = var.security_groups
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "${var.resource_name_prefix}-app-${var.environment}"
    container_port   = var.container_port
  }
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.resource_name_prefix}-logs-${var.environment}"
  retention_in_days = var.logs_retention_period
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.resource_name_prefix}-execution-role-${var.environment}"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ecr_fetch_policy" {
  name        = "${var.resource_name_prefix}-ecr-fetch-policy-${var.environment}"
  description = "Policy to allow ECS tasks to pull images from ECR"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "${var.resource_name_prefix}-task-execution-${var.environment}"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_fetch_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecr_fetch_policy.arn
}
