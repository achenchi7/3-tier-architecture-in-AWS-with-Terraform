variable "instance_type" {
  description = "The type of instance"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key to user for ssh access"
}

variable "instance_name" {
  description = "Unique name for your instance"
  default     = "Terraform-Instance"
}

variable "db_username" {

}

variable "db_password" {

}