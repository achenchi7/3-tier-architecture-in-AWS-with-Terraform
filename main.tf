data "aws_ami" "instance-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }


}

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = "10.0.0.0/16"
  vpc_name        = "my-custom-vpc"
  websubnet1_cidr = "10.0.1.0/24"
  websubnet2_cidr = "10.0.2.0/24"
  appsubnet1_cidr = "10.0.3.0/24"
  appsubnet2_cidr = "10.0.4.0/24"
  dbsubnet1_cidr  = "10.0.5.0/24"
  dbsubnet2_cidr  = "10.0.6.0/24"
  subnet1_az      = "us-east-1a"
  subnet2_az      = "us-east-1b"
}

module "ec2" {
  source            = "./modules/ec2"
  instance_type     = var.instance_type
  subnet_id         = module.vpc.websubnet1
  security_group_id = module.vpc.app-tier-sg
  key_name          = var.key_name
  instance_name     = var.instance_name
}

data "template_file" "app" {
  template = <<EOF
#!/bin/bash
sudo yum install httpd -y
sudo mkdir -p /tmp/webfiles
cd /tmp/webfiles
sudo wget https://www.tooplate.com/zip-templates/2098_health.zip
sudo unzip 2098_health
sudo rm -rf 2098_health.zip
cd 2098_health
sudo cp -r * /var/www/html/
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl restart httpd
sudo rm -rf /tmp/webfiles
EOF
}

module "elb" {
  source             = "./modules/elb"
  subnet_ids         = [module.vpc.websubnet1, module.vpc.websubnet2]
  vpc_id             = module.vpc.vpc_id
  elb_security_group = module.vpc.websubnet1-sg
}

module "asg" {
  source              = "./modules/asg"
  ami_id              = data.aws_ami.instance-ami.id
  instance_type       = var.instance_type
  subnet_ids          = [module.vpc.websubnet1, module.vpc.websubnet2]
  app-tier-subnet-ids = [module.vpc.app-privatesubnet1, module.vpc.app-privatesubnet2]
  #subnet_id            = module.vpc.websubnet1
  key_name             = var.key_name
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  alb_target_group_arn = module.elb.target_group_arn
}

module "database" {
  source               = "./modules/database"
  db-engine            = "mysql"
  db-engine-version    = "8.0"
  db-instance-class    = "db.t3.micro"
  db-allocated-storage = 20
  db-name              = "mydb"
  db-username          = var.db_username
  db-password          = var.db_password
  db-subnet-group-ids  = [module.vpc.db-privatesubnet1, module.vpc.db-privatesubnet2]
  db-security-group-id = [module.vpc.db-sg]
  db-subnet-group-name = [module.vpc.db-privatesubnet1, module.vpc.db-privatesubnet2]
}