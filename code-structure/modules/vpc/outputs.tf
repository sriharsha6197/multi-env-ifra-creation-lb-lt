output "VPC_ID" {
  value = data.aws_vpc.vpc_id.id
}
output "PUBLIC_SUBNETS" {
  value = values(aws_subnet.public_subnets)[*].id
}
output "PRIVATE_SUBNETS" {
  value = values(aws_subnet.private_subnets)[*].id
}