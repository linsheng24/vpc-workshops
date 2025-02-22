
output "public_ip" {
  value = aws_instance.instance.public_ip
}

output "private_ip" {
  value = aws_instance.instance.private_ip
}

output "connection_string" {
  value = "ssh ubuntu@${aws_instance.instance.public_ip}"
}