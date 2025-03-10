# 3-tier-architecture-in-AWS-with-Terraform

## Overview
This project demonstrates how to deploy a scalable, secure, and highly available 3-tier architecture on AWS using Terraform. By leveraging Infrastructure as Code (IaC), this setup ensures automation, reusability, and cost efficiency, making it ideal for businesses looking to scale their applications seamlessly.

## Architecture diagram
![3-tier-arch](https://github.com/achenchi7/3-tier-architecture-in-AWS-with-Terraform/blob/main/assets/3-tier-arch-final.drawio.png)

### Architecture Breakdown
The deployment consists of:

1. **Presentation Layer (Frontend)** – Load balancer distributing traffic to web servers.
![presentation-layer](https://github.com/achenchi7/3-tier-architecture-in-AWS-with-Terraform/blob/main/assets/3-tier-web-tier-frontend.png)

2. **Application Layer (Backend)** – Auto-scaled EC2 instances handling business logic.
![app-tier](https://github.com/achenchi7/3-tier-architecture-in-AWS-with-Terraform/blob/main/assets/3-tier-app-tier.png)

3. **Data Layer (Database)** – Managed RDS instance for data persistence.
![data-tier](https://github.com/achenchi7/3-tier-architecture-in-AWS-with-Terraform/blob/main/assets/3-tier-db-tier.png)

## Key Features
- **Infrastructure as Code** – Fully automated provisioning using Terraform.
- **Scalability** – Auto Scaling Groups adjust resources based on demand.
- **High Availability** – Load balancing and multi-AZ deployment ensure uptime.
- **Security** – IAM roles, security groups, and private networking were implemented.

## How to deploy
1. Clone the repository
```bash
git clone https://github.com/achenchi7/3-tier-architecture-in-AWS-with-Terraform.git
cd 3-tier-architecture-in-AWS-with-Terraform
```
2. Initialize Terraform
```hcl
terraform init
```
3. Preview and apply your infrastructure
```
terraform plan
terraform apply --auto-approve
```
Verify that the resources have been deployed by logging into your AWS management console and access your application through the `elb endpoint`

4. Cleanup resources
To terminate all resources and avoid costs:
```hcl
terraform destroy
```

## Future improvements
This project can further be improved in the following ways:
- Add CI/CD pipeline(s) for automated deployments.
- Implement monitoring and logging with CloudWatch.
- Extend support for multi-region deployment.

# Connect & Feedback
Did you find this useful? Let’s connect on [LinkedIn](https://www.linkedin.com/in/jully-achenchi/), or feel free to open an issue!

