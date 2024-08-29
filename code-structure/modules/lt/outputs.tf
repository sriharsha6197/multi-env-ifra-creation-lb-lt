output "aws_lb_tg" {
  value = values(aws_lb_target_group.tg.id[*], aws_lb_target_group.tg.arn[*])
}