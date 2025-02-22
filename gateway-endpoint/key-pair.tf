resource "aws_key_pair" "key" {
  key_name   = "peering_key"
  public_key = file("~/.ssh/id_rsa.pub")
}