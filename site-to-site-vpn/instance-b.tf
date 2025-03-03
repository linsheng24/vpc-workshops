resource "aws_instance" "instance_b" {
  subnet_id = module.vpc_b.public_subnets[0]
  ami           = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh_b.id, aws_security_group.allow_icmp_b.id]

  tags = {
    Environment = var.environment
  }
}

resource "null_resource" "remote_exec" {
  triggers = {
    once = timestamp()
    # once = aws_instance.instance_b.public_ip
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = aws_instance.instance_b.public_ip
    }

    inline = [
      "sudo apt update",
      "sudo apt install -y libreswan",
      "echo 'net.ipv4.ip_forward = 1\nnet.ipv4.conf.default.rp_filter = 0\nnet.ipv4.conf.default.accept_source_route = 0' | sudo tee /etc/sysctl.conf",
      "sudo sysctl -p",
      "echo 'conn Tunnel1\n  authby=secret\n  auto=start\n  left=%defaultroute\n  leftid=${aws_instance.instance_b.public_ip}\n  leftsubnet=${module.vpc_b.vpc_cidr_block}\n  right=${aws_vpn_connection.vpn.tunnel1_address}\n  rightsubnet=${module.vpc_a.vpc_cidr_block}\n  phase2alg=aes256-sha1;modp2048\n  ike=aes256-sha1-modp2048\n  keyingtries=%forever\n  keyexchange=ike\n  ikelifetime=8h\n  dpddelay=10\n  dpdtimeout=30\n  dpdaction=restart_by_peer' | sudo tee -a /etc/ipsec.d/aws.conf",
      "echo '${aws_instance.instance_b.public_ip} ${aws_vpn_connection.vpn.tunnel1_address} : PSK \"${aws_vpn_connection.vpn.tunnel1_preshared_key}\"' | sudo tee /etc/ipsec.d/aws.secrets",
      "sudo systemctl start ipsec.service",
      "echo 1"
    ]
  }

  depends_on = [aws_instance.instance_b]
}
