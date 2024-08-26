module "vpc" {
  source = "./modules/vpc"
  public_rt_cidr_block = var.public_rt_cidr_block
  vpc_cidr = var.vpc_cidr
  env = var.env
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  from_port = var.from_port
  public_azs = var.public_azs
  private_azs = var.private_azs
}

# module "lb" {
#   source = "./modules/lb"
#   for_each = var.alb_type_internal
#   env = var.env
#   alb_type = each.key
#   internal = each.value
#   public_rt_cidr_block = var.public_rt_cidr_block
#   from_port = var.from_port
#   vpc_id = module.vpc.VPC_ID
#   SUBNETS = each.value == "false" ? module.vpc.PUBLIC_SUBNETS : module.vpc.PRIVATE_SUBNETS
# }

# module "lt" {
#   source = "./modules/lt"
#   env = var.env
#   for_each = var.components
#   vpc_cidr = var.vpc_cidr
#   image_id = module.vpc.IMAGE_ID
#   instance_type = var.instance_type
#   vpc_id = module.vpc.VPC_ID
#   components = each.value
#   from_port = var.from_port
#   public_rt_cidr_block = var.public_rt_cidr_block
#   private_subnets = module.vpc.PRIVATE_SUBNETS
#   terraform_controller_instance = var.terraform_controller_instance
# }

module "rds" {
  source = "./modules/rds"
  component = var.component
  engine = var.engine
  env = var.env
  engine_version = var.engine_version
  private_subnets = module.vpc.PRIVATE_SUBNETS
  vpc_id = module.vpc.VPC_ID
  public_rt_cidr_block = var.public_rt_cidr_block
  from_port = var.from_port
}