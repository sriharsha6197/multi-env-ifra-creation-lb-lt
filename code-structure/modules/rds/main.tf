resource "aws_security_group" "allow_tls" {
  name        = "${var.env}-sec-grp-rds-${var.component}"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-sec-grp-rds-${var.component}"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  for_each = var.from_port
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.vpc_id
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.vpc_id
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.public_rt_cidr_block
  ip_protocol       = "-1"
}


resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.env}-db-subnet-group"
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "${var.env}-rds-cluster"
  engine                  = var.engine
  engine_version          = var.engine_version

  database_name           = "expenseDB"
  db_subnet_group_name    = aws_db_subnet_group.main.id
  master_username         = data.aws_ssm_parameter.master_username.value
  master_password         = data.aws_ssm_parameter.master_password.value
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
}