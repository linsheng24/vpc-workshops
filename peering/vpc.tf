module "vpc_a" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-a"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    Environment = "sandbox"
  }
}

module "vpc_b" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-a"
  cidr = "10.1.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]

  tags = {
    Environment = var.environment
  }
}

resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id   = module.vpc_a.vpc_id
  vpc_id        = module.vpc_b.vpc_id
  auto_accept   = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_route" "route_a_to_b" {
  route_table_id            = module.vpc_a.public_route_table_ids[0]
  destination_cidr_block    = module.vpc_b.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "route_b_to_a" {
  route_table_id            = module.vpc_b.private_route_table_ids[0]
  destination_cidr_block    = module.vpc_a.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}