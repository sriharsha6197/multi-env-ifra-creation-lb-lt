resource "aws_security_group" "allow_tls" {
  name        = "${var.env}-sec-grp-lb-${var.components}"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-sec-grp-lb-${var.components}"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  for_each = var.from_port
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}
resource "aws_vpc_security_group_ingress_rule" "ingress_rule" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.terraform_controller_instance
  from_port         = 22
  ip_protocol       = "tcp"
  to_port = 22
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.public_rt_cidr_block
  ip_protocol       = "-1"
}

resource "aws_iam_role" "test_role" {
  name = "${var.env}-${var.components}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.env}-${var.components}-role"
  }
}
resource "aws_iam_role_policy" "test_policy" {
  name = "${var.env}-role-pilcy-${var.components}"
  role = aws_iam_role.test_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_instance_profile" "test_profile" {
  name = "${var.env}-instance-profile-${var.components}"
  role = aws_iam_role.test_role.name
}


resource "aws_launch_template" "foo" {
  name = "${var.env}-lt-${var.components}"
  iam_instance_profile {
    name = aws_iam_instance_profile.test_profile.name
  }
  image_id = var.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data = base64encode(templatefile("${path.module}/app_data.sh",{
    component = var.components
  }))
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-${var.components}"
    }
  }

}
resource "aws_autoscaling_group" "bar" {
  name = "${var.env}-${var.components}-asg"
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier = var.private_subnets
  target_group_arns = [aws_lb_target_group.tg.arn]
  launch_template {
    id      = aws_launch_template.foo.id
    version = "$Latest"
  }
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.env}-${var.components}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id = var.vpc_id
}