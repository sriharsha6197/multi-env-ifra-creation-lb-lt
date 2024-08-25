resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}
resource "aws_subnet" "public_subnets" {
  for_each = zipmap(range(length(var.public_subnets)),var.public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[each.key]

  tags = {
    Name = "${var.env}-public-subnet-${each.key + 1}"
  }
}
resource "aws_subnet" "private_subnets" {
  for_each = zipmap(range(length(var.private_subnets)),var.private_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnets[each.key]

  tags = {
    Name = "${var.env}-private-subnet-${each.key + 1}"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}
resource "aws_route_table" "public_route_tables" {
  for_each = zipmap(range(length(var.public_subnets)),var.public_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_rt_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-route-table-${each.key + 1}"
  }
}
resource "aws_route_table_association" "pb-rt-association" {
  for_each = zipmap(range(length(var.public_subnets)),var.public_subnets) 
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public_route_tables[each.key].id
}
resource "aws_eip" "eip" {
  count = 2
  domain   = "vpc"
}
resource "aws_nat_gateway" "nat_gw" {
  for_each = zipmap(range(length(var.public_subnets)),var.public_subnets)
  allocation_id = aws_eip.eip[each.key].id
  subnet_id     = aws_subnet.public_subnets[each.key].id
  tags = {
    Name = "${var.env}-nat-gw-${each.key + 1}"
  }
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_route_table" "private_route_tables" {
  for_each = zipmap(range(length(var.private_subnets)),var.private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_rt_cidr_block
    gateway_id = aws_nat_gateway.nat_gw[each.key].id
  }
  tags = {
    Name = "${var.env}-private-route-table-${each.key + 1}"
  }
}
resource "aws_route_table_association" "pvt_rt_assocation" {
  for_each = zipmap(range(length(var.private_subnets)),var.private_subnets) 
  subnet_id      = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.private_route_tables[each.key].id
}
resource "aws_security_group" "allow_tls" {
  name        = "${var.env}-sec-grp"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.env}-sec-grp"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.public_rt_cidr_block
  from_port         = var.from_port
  ip_protocol       = "tcp"
  to_port           = var.from_port
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.public_rt_cidr_block
  ip_protocol       = "-1"
}