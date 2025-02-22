
output "public_ip_a" {
  value = aws_instance.instance_a.public_ip
}

output "private_ip_a" {
  value = aws_instance.instance_a.private_ip
}

output "private_ip_b" {
  value = aws_instance.instance_b.private_ip
}

output "connection_string" {
  value = "ssh ubuntu@${aws_instance.instance_b.private_ip} -oProxyCommand='ssh ubuntu@${aws_instance.instance_a.public_ip} -i ~/.ssh/id_rsa -W %h:%p' -i ~/.ssh/id_rsa"
}