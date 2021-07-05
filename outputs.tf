output "cloudwatch_log_group" {
  description = "Name of the CloudWatch log group for container logs."
  value       = aws_cloudwatch_log_group.containers.name
}

output "ecs_task_exec_role_name" {
  description = "ECS task role used by this service."
  value       = aws_iam_role.ecs_task_role.name
}
