output "aws_lb_tg" {
  value = aws_lb_target_group.tg[each.value].arn
}