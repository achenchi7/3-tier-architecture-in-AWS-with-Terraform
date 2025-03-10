variable "db-engine" {
  description = "The database engine to use"
  type = string
}

variable "db-engine-version" {
  description = "The version of databse engine"
  type = string
}

variable "db-instance-class" {
  description = "The instance type of the RDS instance"
  type = string
}

variable "db-allocated-storage" {
  description = "The allocated storage in gigabytes"
  type = number
  default = 20
}

variable "db-name" {
  description = "The name of the database"
  type = string
}

variable "db-username" {
  description = "The master username for the database"
  type = string
}

variable "db-password" {
  description = "The master password of the database"
  type = string
  sensitive = true
}

variable "db-security-group-id" {
  description = "The security group ID for the RDS instance"
  type = list(string)
}

variable "skip-final-snapshot" {
  description = "Determines whether to skip the final snapshot before deletion"
  type = bool
  default = true
}

variable "db-subnet-group-ids" {
  description = "The security group ID for the RDS instance"
  type = list(string)
}
variable "db-subnet-group-name" {
  
}



variable "db-backup-retention" {
  description = "The number of days to retain backups for"
  default = 7
  type = number
}