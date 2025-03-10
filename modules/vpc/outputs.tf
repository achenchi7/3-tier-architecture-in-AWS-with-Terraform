output "websubnet1" {
  value = aws_subnet.publicsubnet1.id
}

output "websubnet2" {
  value = aws_subnet.publicsubnet2.id
}

/**output "db-subnet-group" {
  description = "List of private subnet IDS"
  value = aws_db_subnet_group.db-subnet-group.id
}**/

output "db-sg" {
  value = aws_security_group.db-sg.id
}

output "db-privatesubnet1" {
  value = aws_subnet.db-privatesubnet1.id
}

output "db-privatesubnet2" {
  value = aws_subnet.db-privatesubnet2.id
}

output "websubnet1-sg" {
  value = aws_security_group.web-subnet1-sg.id
}

output "websubnet2-sg" {
  value = aws_security_group.web-subnet2-sg.id
}

output "vpc_id" {
  value = aws_vpc.main-vpc.id
}

output "app-tier-sg" {
  value = aws_security_group.app-tier-sg.id
}

/**output "db-subnet-group" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.db-privatesubnet1.id, aws_subnet.db-privatesubnet2.id]
}**/

output "app-privatesubnet1" {
  value = aws_subnet.app-privatesubnet1.id
}

output "app-privatesubnet2" {
  value = aws_subnet.app-privatesubnet2.id
}








