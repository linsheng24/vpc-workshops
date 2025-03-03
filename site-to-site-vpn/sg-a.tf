resource "aws_security_group" "allow_icmp_a" {
  name        = "allow_icmp_a"
  description = "Allow ICMP inbound traffic"
  vpc_id = module.vpc_a.vpc_id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
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