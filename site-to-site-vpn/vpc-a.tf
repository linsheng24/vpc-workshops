module "vpc_a" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-a"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    Environment = var.environment
  }
}

resource "aws_vpn_gateway" "vgw" {
  vpc_id = module.vpc_a.vpc_id
}

resource "aws_route" "vpn_route" {
  count = length(module.vpc_a.private_route_table_ids)
  route_table_id         = module.vpc_a.private_route_table_ids[count.index]
  destination_cidr_block = module.vpc_b.vpc_cidr_block
  gateway_id             = aws_vpn_gateway.vgw.id
}

resource "aws_vpn_gateway_attachment" "vpc_attachment" {
  vpc_id        = module.vpc_a.vpc_id
  vpn_gateway_id = aws_vpn_gateway.vgw.id
}