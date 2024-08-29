output "aws_lb_tg" {
  value = zipmap(aws_lb_target_group.tg[*].arn,aws_lb_target_group.tg[*].name)
}