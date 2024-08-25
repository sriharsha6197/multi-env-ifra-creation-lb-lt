module "vpc" {
  source = "./modules/vpc"
  public_rt_cidr_block = var.public_rt_cidr_block
  vpc_cidr = var.vpc_cidr
  env = var.env
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  from_port = var.from_port
}