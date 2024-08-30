output "aws_lb_tg" {
  value = resource.aws_lb_target_group.tg[*].arn
}