module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "sqs_endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.sqs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = module.vpc.private_subnets
  private_dns_enabled = true

  security_group_ids = [aws_security_group.sqs_endpoint_sg.id]

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "sqs_endpoint_sg" {
  name        = "sqs-endpoint-sg"
  description = "Security group for SQS VPC endpoint"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}