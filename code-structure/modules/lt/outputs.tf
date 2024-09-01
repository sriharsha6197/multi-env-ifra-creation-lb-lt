output "aws_lb_tg" {
  value = {
    for tg in var.alb_type_internal : tg.name => lookup(zipmap(range(length(aws_lb_target_group.tg[*].name)),aws_lb_target_group.tg[*].name),"arn","Not Found")
  }
}

