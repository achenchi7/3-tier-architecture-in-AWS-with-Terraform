variable "ami_id" {
  description = "The ami_id of the desired instance(s)"
}

variable "instance_type" {
  description = "The desired type of instance"
}

variable "key_name" {
  description = "The name of your SSH key to connect to the instances"
}

/**variable "subnet_id" {
  type = string
}**/

variable "min_size" {
  description = "The lowest number of instances that should run at all times"
}

variable "max_size" {
  description = "The maximum number of instances during spikes"
}

variable "desired_capacity" {
  description = "The median number of instances"
}

variable "subnet_ids" {
  type = list(string)
}

variable "alb_target_group_arn" {
  
}

variable "app-tier-subnet-ids" {
  type = list(string)
}
