resource "aws_instance" "instance_b" {
  subnet_id = module.vpc_b.private_subnets[0]
  ami           = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh_b.id]

  tags = {
    Environment = var.environment
  }
}