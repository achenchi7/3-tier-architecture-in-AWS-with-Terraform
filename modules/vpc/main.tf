#--------------------VPC---------------------------
# Create custom vpc
resource "aws_vpc" "main-vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    name = var.vpc_name
  }
}

#===============================================================
#---------------------SUBNETS FOR THE 3 TIERS-------------------

# Create tier 1 (web tier) subnets - Public subnets
resource "aws_subnet" "publicsubnet1" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = var.websubnet1_cidr
  availability_zone = var.subnet1_az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-web-subnet1"
  }
}

resource "aws_subnet" "publicsubnet2" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = var.websubnet2_cidr
  availability_zone = var.subnet2_az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-web-subnet2"
  }
}

# Create tier 2 (app tier) subnets - Private subnets
resource "aws_subnet" "app-privatesubnet1" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = var.appsubnet1_cidr
  availability_zone = var.subnet1_az
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.vpc_name}-app-subnet1"
  }
}

resource "aws_subnet" "app-privatesubnet2" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = var.appsubnet2_cidr
  availability_zone = var.subnet2_az
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.vpc_name}-app-subnet2"
  }
}

# Create tier 3 (db tier) subnets - Private subnets
resource "aws_subnet" "db-privatesubnet1" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = var.dbsubnet1_cidr
  availability_zone = var.subnet1_az
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.vpc_name}-db-subnet1"
  }
}

resource "aws_subnet" "db-privatesubnet2" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = var.dbsubnet2_cidr
  availability_zone = var.subnet2_az
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.vpc_name}-db-subnet2"
  }
}

#===================================================================
#-------------INTERNET CONNECTIVITY (EIP, NAT, & igw)---------------

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

# NAT Gateway for outbound traffic from private subnets
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.publicsubnet1.id

  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Internet gateway for public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

#===============================================================
#--------------------PUBLIC & PRIVATE ROUTE TABLES---------------

# Private route table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# Private route table routes
resource "aws_route" "private-route" {
  route_table_id = aws_route_table.private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

# Associate private subnet 1 (app tier) with private route table
resource "aws_route_table_association" "app-privatesubnet1-association" {
  subnet_id = aws_subnet.app-privatesubnet1.id
  route_table_id = aws_route_table.private-rt.id
}

# Associate private subnet 2 (app tier) with private route table
resource "aws_route_table_association" "app-privatesubnet2-association" {
  subnet_id = aws_subnet.app-privatesubnet2.id
  route_table_id = aws_route_table.private-rt.id
}

# Associate private subnet 1 (db tier) with private route table
resource "aws_route_table_association" "db-privatesubnet1-association" {
  subnet_id = aws_subnet.db-privatesubnet1.id
  route_table_id = aws_route_table.private-rt.id
}

# Associate private subnet 2 (db tier) with private route table
resource "aws_route_table_association" "db-privatesubnet2-association" {
  subnet_id = aws_subnet.db-privatesubnet2.id
  route_table_id = aws_route_table.private-rt.id
}

#-------------------------------------------------------------
# Public route table
resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.main-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "${var.vpc_name}-main-rt"
  }
}

# Associate Web tier public subnet 1 with main route table
resource "aws_route_table_association" "publicsubnet1-association" {
  subnet_id = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.main-rt.id
}

# Associate Web tier public subnet 2 with main route table
resource "aws_route_table_association" "publicsubnet2-association" {
  subnet_id = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.main-rt.id
}

#====================================================================
# Database subnet group
resource "aws_db_subnet_group" "db-subnet-group" {
  name = "${var.vpc_name}-db-subnet-group"
  subnet_ids = [aws_subnet.db-privatesubnet1.id, aws_subnet.db-privatesubnet2.id]
  tags = {
    Name = "${var.vpc_name}-db-subnet-group"
  }
}

#====================================================================
#---------------------------SECURITY GROUP---------------------------

# Security group for app tier
resource "aws_security_group" "app-tier-sg" {
  name = "${var.vpc_name}-app-tier-sg"
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "${var.vpc_name}-app-tier-sg"
  }

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for web tier
resource "aws_security_group" "web-subnet1-sg" {
  name = "${var.vpc_name}-web-tier-sg"
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "${var.vpc_name}-web-tier-sg"
  }
}

resource "aws_security_group" "web-subnet2-sg" {
  name = "${var.vpc_name}-bastion-sg"
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "${var.vpc_name}-bastion-sg"
  }
}

# Security group for db tier
resource "aws_security_group" "db-sg" {
  vpc_id = aws_vpc.main-vpc.id
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.app-tier-sg.id]
  }

  tags = {
    Name = "${var.vpc_name}-db-sg"
  }
}