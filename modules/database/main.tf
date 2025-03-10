# Primary RDS Instance
resource "aws_db_instance" "primary-RDS" {
  allocated_storage = var.db-allocated-storage
  engine = var.db-engine
  engine_version = var.db-engine-version
  instance_class = var.db-instance-class
  db_name = var.db-name
  username = var.db-username
  password = var.db-password
  publicly_accessible = false
  multi_az = true
  storage_type = "gp2"
  vpc_security_group_ids = var.db-security-group-id 
  db_subnet_group_name = aws_db_subnet_group.db-subnet-grp.id
  skip_final_snapshot = true
  backup_retention_period = 0
  tags = {
    Name = "${var.db-name}-primary"
  }
}

resource "aws_db_subnet_group" "db-subnet-grp" {
  name = "${var.db-name}-subnet-group"
  subnet_ids = var.db-subnet-group-ids
  tags = {
    Name = "${var.db-name}-subnet-group"
  }
}

