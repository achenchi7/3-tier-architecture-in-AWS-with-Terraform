output "primary-db-endpoint" {
  description = "The endpoint of the primary DB instance"
  value       = aws_db_instance.primary-RDS.endpoint
}

output "primary-db-arn" {
  description = "The ARN of the primary database"
  value       = aws_db_instance.primary-RDS.arn
}