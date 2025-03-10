# A launch template for the EC2 instances
resource "aws_launch_template" "asg-launch-template" {
  name = "Launch-template" # 
  image_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
    network_interfaces {
      subnet_id = var.subnet_ids[0]
      associate_public_ip_address = true

    }

            tags = {
              Name = "Launch-template-instance"
            }

    
    user_data = "${base64encode(data.template_file.test.rendered)}"

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "asg" {
    name = "3-tier-asg" # Name of the auto-scaling group
    min_size = var.min_size # Required parameter. The min size of the asg
    max_size = var.max_size # Required parameter. The max size of the asg
    desired_capacity = var.desired_capacity
    health_check_grace_period = 300
    health_check_type = "EC2" # Choices are 'EC2' or 'ELB'. Controls how health checking is done.
    vpc_zone_identifier = var.subnet_ids # A list of subnet ids to place the instances in. Subnets automatically determine
    # which availability zones the instances will be created in

    launch_template {
      id = aws_launch_template.asg-launch-template.id
      version = aws_launch_template.asg-launch-template.latest_version
    }
    

    target_group_arns = [ var.alb_target_group_arn ]

    lifecycle {
      create_before_destroy = true
    }
}

data "template_file" "test" {
  template = <<EOF
#!/bin/bash
sudo yum install wget unzip httpd -y
sudo mkdir -p /tmp/webfiles
cd /tmp/webfiles
sudo wget https://www.tooplate.com/zip-templates/2098_health.zip
sudo unzip 2098_health
sudo rm -rf 2098_health.zip
cd 2098_health
sudo cp -r * /var/www/html/
sudo systemctl start httpd
sudo systemctl enable httpd
sudo rm -rf /tmp/webfiles
EOF
}

# A launch template for the EC2 instances - App-tier
resource "aws_launch_template" "app-tier-asg-launch-template" {
  name = "Launch-template-AppTier" 
  image_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
    network_interfaces {
      subnet_id = var.subnet_ids[0]
      associate_public_ip_address = true

    }

            tags = {
              Name = "Launch-template-instance"
            }

    
    user_data = "${base64encode(data.template_file.app-test.rendered)}"

    lifecycle {
      create_before_destroy = true
    }
}

# An EC2 Auto Scaling Group for the Apptier
resource "aws_autoscaling_group" "app-tier-asg" {
    name = "3-tier-asg-app"
    min_size = var.min_size 
    max_size = var.max_size 
    desired_capacity = var.desired_capacity
    health_check_grace_period = 300
    health_check_type = "EC2" 
    vpc_zone_identifier = var.app-tier-subnet-ids 

    launch_template {
      id = aws_launch_template.app-tier-asg-launch-template.id
      version = aws_launch_template.app-tier-asg-launch-template.latest_version
    }

    target_group_arns = [ var.alb_target_group_arn ]

    lifecycle {
      create_before_destroy = true
    }
}

data "template_file" "app-test" {
  template = <<EOF
#!/bin/bash
sudo yum install mysql -y
EOF
}