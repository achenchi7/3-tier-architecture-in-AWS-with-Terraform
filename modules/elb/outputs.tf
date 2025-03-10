output "eld_dns_name" {
  value = aws_lb.elb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.web_target_group.arn
  description = "ARN of the target group associated with the ELB"
}
