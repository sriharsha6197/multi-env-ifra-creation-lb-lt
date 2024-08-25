variable "vpc_cidr" {
  
}
variable "env" {
  
}
variable "public_subnets" {
  
}
variable "private_subnets" {
  
}
variable "public_rt_cidr_block" {
  
}
variable "from_port" {
  type = set(string)
}
variable "alb_type" {
  
}
variable "internal" {
  
}
variable "SUBNETS" {
  
}
variable "alb_type_internal" {
  type = map(string)
  default = {
    
  }
}
variable "vpc_id" {
  
}
variable "public_azs" {
  
}
variable "private_azs" {
  
}
variable "image_id" {
  
}
variable "instance_type" {
  
}
variable "components" {
  type = set(string)
}
variable "terraform_controller_instance" {
  
}