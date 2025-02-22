resource "aws_iam_role" "sqs_access_role" {
  name = "sqs-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "sqs_access_policy" {
  name        = "sqs-access-policy"
  description = "Policy to allow access to SQS queue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
        ]
        Resource = aws_sqs_queue.terraform_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sqs_access_attachment" {
  role       = aws_iam_role.sqs_access_role.name
  policy_arn = aws_iam_policy.sqs_access_policy.arn
}

resource "aws_iam_instance_profile" "sqs_access_instance_profile" {
  name = "sqs-access-instance-profile"
  role = aws_iam_role.sqs_access_role.name
}