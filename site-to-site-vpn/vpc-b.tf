module "vpc_b" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-b"
  cidr = "10.1.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]

  tags = {
    Environment = var.environment
  }
}

resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = aws_instance.instance_b.public_ip
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "vpn_route" {
  destination_cidr_block = module.vpc_b.vpc_cidr_block
  vpn_connection_id      = aws_vpn_connection.vpn.id
}