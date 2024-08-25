vpc_cidr = "192.168.0.0/16"
env = "dev"
public_subnets = ["192.168.1.0/24","192.168.2.0/24"]
private_subnets = ["192.168.3.0/24","192.168.4.0/24"]
public_rt_cidr_block = "0.0.0.0/0"
from_port = [443,80,22]