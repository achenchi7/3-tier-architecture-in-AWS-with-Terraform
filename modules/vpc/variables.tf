variable "vpc_name" {
  description = "Name of the Custom VPC"
  type = string
}
variable "vpc_cidr" {
  description = "CIDR Block for Custom VPC"
  type = string
}

variable "websubnet1_cidr" {
  description = "CIDR block for the web tier subnet1"
  type = string
}

variable "websubnet2_cidr" {
  description = "CIDR block for the web tier subnet2"
  type = string
}

variable "appsubnet1_cidr" {
  description = "CIDR block for the app tier subnet1"
  type = string
}

variable "appsubnet2_cidr" {
  description = "CIDR block for the app tier subnet2"
  type = string
}

variable "dbsubnet1_cidr" {
  description = "CIDR block for the db tier subnet1"
  type = string
}
variable "dbsubnet2_cidr" {
  description = "CIDR block for the db tier subnet2"
  type = string
}
variable "subnet1_az" {
  description = "Availability zone for subnet 1"
  type = string
}
variable "subnet2_az" {
  description = "Availability zone for subnet 2"
  type = string
}