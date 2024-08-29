output "aws_lb_tg" {
  value = values({ "arn" : "aws_lb_target_group.tg.arn[*]"})
}