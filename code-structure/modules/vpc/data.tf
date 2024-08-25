data "aws_vpc" "vpc_id" {
  id = var.vpc_id
}
variable "vpc_id" {
  default = "vpc-022ea442fc79898cb"
}
data "aws_vpc" "default_vpc" {
  id = var.default_vpc
}
variable "default_vpc" {
  default = "vpc-019eb600d42615e77"
}