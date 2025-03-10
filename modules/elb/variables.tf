variable "vpc_id" {
  description = "The id of the VPC"
}

variable "elb_security_group" {
  description = "The security groups"
  type = string
}



variable "subnet_ids" {
  description = "List of subnet IDs where the ALB will be deployed"
}
