resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-workshop-example-s3-bucket"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny",
        Principal = "*",
        Action = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"
        ],
        Condition = {
          StringNotEquals = {
            "aws:sourceVpce": "${aws_vpc_endpoint.s3_endpoint.id}"
          }
        }
      },
    ]
  })
}