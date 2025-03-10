output "autoscaling_group_name" {
  description = "The name of the created auto scaling group"
  value = aws_autoscaling_group.asg.name
}

output "aws_launch_name" {
  description = "The name of the created Launch configuration"
  value = aws_launch_template.asg-launch-template.name
}