resource "aws_instance" "instance_a" {
  subnet_id = module.vpc_a.private_subnets[0]
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.allow_icmp_a.id]

  tags = {
    Environment = var.environment
  }
}