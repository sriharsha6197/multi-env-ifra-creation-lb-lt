output "aws_lb_tg" {
  value = {for k, v in aws_lb_target_group.tg: k => v.arn}
}