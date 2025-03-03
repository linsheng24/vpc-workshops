output "public_ip_b" {
  value = aws_instance.instance_b.public_ip
}

output "private_ip_a" {
  value = aws_instance.instance_a.private_ip
}

output "connection_string" {
  value = "ssh ubuntu@${aws_instance.instance_b.public_ip}"
}

output "ping_command_from_b_to_a" {
  value = "ssh ubuntu@${aws_instance.instance_b.public_ip} 'ping ${aws_instance.instance_a.private_ip}'"
}