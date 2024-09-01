output "aws_lb_tg" {
  value = lookup(aws_lb_target_group.tg[name],"arn","Not Found")
}

