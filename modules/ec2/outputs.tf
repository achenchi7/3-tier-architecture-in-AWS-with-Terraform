output "ec2_instances" {
  value = aws_instance.webserver-instance.id
}