output "aws_lb_tg" {
  value = values(name, aws_lb_target_group.tg.arn[*])
}