resource "aws_instance" "instance_b" {
  subnet_id = module.vpc.private_subnets[0]
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  iam_instance_profile        = aws_iam_instance_profile.sqs_access_instance_profile.name

  tags = {
    Environment = var.environment
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.private_ip
      bastion_host = aws_instance.instance_a.public_ip
      bastion_user = "ubuntu"
      bastion_private_key = file("~/.ssh/id_rsa")
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y unzip",
      "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\"",
      "unzip awscliv2.zip",
      "sudo ./aws/install"
    ]
  }
}
