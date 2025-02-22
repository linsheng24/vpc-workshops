resource "aws_instance" "instance" {
  subnet_id = module.vpc.public_subnets[0]
  ami           = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  iam_instance_profile        = aws_iam_instance_profile.s3_access_instance_profile.name

  tags = {
    Environment = var.environment
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
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

resource null_resource "copy_file" {
  triggers = {
    instance_id = timestamp()
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = aws_instance.instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello, World!' > hello.txt",
      "aws s3 cp hello.txt s3://${aws_s3_bucket.s3_bucket.bucket}/hello.txt"
    ]
  }
}