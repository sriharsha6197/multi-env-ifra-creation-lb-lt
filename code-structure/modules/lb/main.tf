resource "aws_security_group" "allow_tls" {
  name        = "${var.env}-sec-grp-lb"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-sec-grp-lb"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  for_each = var.from_port
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.public_rt_cidr_block
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.public_rt_cidr_block
  ip_protocol       = "-1"
}

resource "aws_lb" "test" {
  name               = "${var.env}-${var.alb_type}-lb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.SUBNETS

  tags = {
    Environment = "${var.env}-${var.alb_type}-lb"
  }
}