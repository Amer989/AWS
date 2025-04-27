provider "aws" {
  region = "us-east-1"
  access_key = "xxxxxxx"
 secret_key = "xxxxxxx"
}
terraform {
  required_version = "1.4.6"
}
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role_shutdownResources30Days"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = "production"
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_policy_shutdownResources30Days"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Action: [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:Describe*",
          "ec2:TerminateInstance"
        ],
        Resource: "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "lambda_function" {
  filename         = "lambda.py.zip"
  function_name    = "Shutdow_Resources_30DaysLambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda.lambda_handler"

  runtime          = "python3.8"
  timeout          = 60



  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attachment  ]
}




resource "aws_cloudwatch_event_rule" "lambda_trigger" {
  name                = "lambda-trigger-ShutdownResources30Days"
  description         = "Trigger the Lambda function "
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_trigger.name
  arn       = aws_lambda_function.lambda_function.arn

}
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_trigger.arn
}
