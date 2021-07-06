## the VPC's default SG must be attached to allow traffic from/to AWS endpoints like ECR
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = var.vpc_id
}


resource "aws_ecs_service" "this" {
  cluster                            = var.cluster_id
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = var.desired_count
  force_new_deployment               = var.force_new_deployment
  health_check_grace_period_seconds  = 0
  launch_type                        = "FARGATE"
  name                               = "${var.service_name}-${var.env}"
  platform_version                   = var.platform_version
  propagate_tags                     = "SERVICE"
  task_definition                    = "${aws_ecs_task_definition.this.family}:${max(aws_ecs_task_definition.this.revision, data.aws_ecs_task_definition.this.revision)}"

  dynamic "load_balancer" {
    for_each = aws_alb_target_group.main
    content {
      container_name   = local.container_name
      container_port   = load_balancer.value.port
      target_group_arn = load_balancer.value.arn
    }
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [data.aws_security_group.default.id, var.sg_for_fargate]
    assign_public_ip = var.assign_public_ip
  }
}

resource "aws_ecs_task_definition" "this" {
  container_definitions    = var.container_definitions
  cpu                      = var.cpu
  execution_role_arn       = var.task_execution_role_arn
  family                   = "${var.service_name}-${var.env}"
  memory                   = var.memory
  network_mode             = "awsvpc"
  requires_compatibilities = var.requires_compatibilities
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

# Simply specify the family to find the latest ACTIVE revision in that family.
data "aws_ecs_task_definition" "this" {
  depends_on      = [aws_ecs_task_definition.this]
  task_definition = aws_ecs_task_definition.this.family
}

locals {
  container_name = var.container_name == "" ? var.service_name : var.container_name
}
