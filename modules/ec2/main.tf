
data "aws_ami" "instance-ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "owner-alias"
    values = [ "amazon" ]
  }

  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-x86_64-gp2" ]
  }


}

resource "aws_instance" "webserver-instance" {
  ami = data.aws_ami.instance-ami.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name = var.key_name
  
  security_groups = [ var.security_group_id ]

  user_data = "${base64encode(data.template_file.app.rendered)}"

  tags = {
    Name = var.instance_name
  }
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