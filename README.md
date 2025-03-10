# 3-tier-architecture-in-AWS-with-Terraform

## Overview
This project demonstrates how to deploy a scalable, secure, and highly available 3-tier architecture on AWS using Terraform. By leveraging Infrastructure as Code (IaC), this setup ensures automation, repusability, and cost efficiency, making it ideal for businesses looking to scale their applications seamlessly.

### Architecture Breakdown
The deployment consists of:

- Presentation Layer (Frontend) – Load balancer distributing traffic to web servers.
![presentation-layer](D:\terraform-projects\3-tier-architecture\assets\3-tier-web-tier-frontend.png)
- Application Layer (Backend) – Auto-scaled EC2 instances handling business logic.
- Data Layer (Database) – Managed RDS instance for data persistence.

## Key Features
- **Infrastructure as Code** – Fully automated provisioning using Terraform.
- **Scalability** – Auto Scaling Groups adjust resources based on demand.
- **High Availability** – Load balancing and multi-AZ deployment ensure uptime.
- **Security** – IAM roles, security groups, and private networking implemented.