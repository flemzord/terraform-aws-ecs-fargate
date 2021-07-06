resource "aws_cloudwatch_log_group" "containers" {
  name              = "/aws/ecs/${var.env}/${var.service_name}"
  retention_in_days = 7
}

data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.containers.arn}:*"
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  path   = "/ecs/task-role/${var.env}"
  policy = data.aws_iam_policy_document.cloudwatch_logs_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}
