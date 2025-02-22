module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    Environment = var.environment
  }
}

resource aws_vpc_endpoint "s3_endpoint" {
  vpc_id = module.vpc.vpc_id
  service_name = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids  = concat(module.vpc.public_route_table_ids, module.vpc.private_route_table_ids)

  tags = {
    Environment = var.environment
  }
}