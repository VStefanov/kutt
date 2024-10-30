
resource "aws_cloudwatch_metric_alarm" "app_cpu_high" {
  alarm_name          = "${var.resource_name_prefix}-app-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/ECS"
  period             = "300"
  statistic          = "Average"
  threshold          = 80
  alarm_description  = "Alarm when ECS CPU exceeds 80%"

  dimensions = {
    ClusterName = var.ecs_cluster_id
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_sns_topic.app_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "db_cpu_high" {
  alarm_name          = "${var.resource_name_prefix}-db-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/Usage"
  period             = "300"
  statistic          = "Average"
  threshold          = 80
  alarm_description  = "Alarm when Aurora CPU exceeds 80%"

  dimensions = {
    DBInstanceIdentifier = var.aurora_cluster_id
  }

  alarm_actions = [aws_sns_topic.db_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "db_memory_high" {
  alarm_name          = "${var.resource_name_prefix}-db-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "AuroraMemoryHealthState"
  namespace           = "AWS/Usage"
  period              = "300"
  statistic           = "Average"
  threshold           = 9
  alarm_description   = "Alarm when Aurora is approaching critical level of memory usage."

  dimensions = {
    DBInstanceIdentifier = var.aurora_cluster_id
  }

  alarm_actions = [aws_sns_topic.db_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory_high" {
  alarm_name          = "${var.resource_name_prefix}-cache-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = "UsedMemory"
  namespace          = "AWS/ElastiCache"
  period             = "300"
  statistic          = "Average"
  threshold          = 1000000000
  alarm_description  = "Alarm when ElastiCache memory usage exceeds 1 GB"

  dimensions = {
    CacheClusterId = var.redis_cluster_id
  }

  alarm_actions = [aws_sns_topic.redis_alerts.arn]
}

resource "aws_sns_topic" "app_alerts" {
  name = "${var.resource_name_prefix}-app-alerts"
}

resource "aws_sns_topic" "cache_alerts" {
  name = "${var.resource_name_prefix}-cache-alerts"
}

resource "aws_sns_topic" "db_alerts" {
  name = "${var.resource_name_prefix}-db-alerts"
}

resource "aws_sns_topic_subscription" "app_alerts_email" {
  topic_arn = aws_sns_topic.app_alerts.arn
  protocol  = "email"
  endpoint  = var.aler_subscriber_email
}

resource "aws_sns_topic_subscription" "cache_alerts_email" {
  topic_arn = aws_sns_topic.cache_alerts.arn
  protocol  = "email"
  endpoint  = var.aler_subscriber_email
}

resource "aws_sns_topic_subscription" "db_alerts_email" {
  topic_arn = aws_sns_topic.db_alerts.arn
  protocol  = "email"
  endpoint  = var.aler_subscriber_email
}