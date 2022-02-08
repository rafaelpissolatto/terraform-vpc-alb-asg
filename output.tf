// Here you can print things out to the console

output "alb_dns_name" {
  value = aws_lb.example-alb.dns_name
}

output "aws_autoscaling_group_name" {
  value = aws_autoscaling_group.example-autoscale-group.name
}