output "aws_lb_tg" {
  value = {
    for tg in var.alb_type_internal : tg.name => lookup(aws_lb_target_group.tg[*].name,"arn","Not Found")
  }
}

