vpc_cidr = "192.168.0.0/16"
env = "dev"
public_subnets = ["192.168.1.0/24","192.168.2.0/24"]
private_subnets = ["192.168.3.0/24","192.168.4.0/24"]
public_rt_cidr_block = "0.0.0.0/0"
from_port = [443,80,22]
alb_type_internal = {
    public = {
        internal = "false",
        port = 80,
        protocol = "HTTP",
    }
    private = {
        internal = true
        port = 8080
        protocol = "HTTP"
    }
}
public_azs = ["us-east-1a","us-east-1b"]
private_azs = ["us-east-1c","us-east-1d"]
SUBNETS = ""
alb_type = ""
internal = ""
vpc_id = ""
image_id = ""
instance_type = "t3.micro"
components = ["frontend","backend"]
terraform_controller_instance = "172.31.45.11/32"
engine = "aurora-mysql"
engine_version = "5.7.mysql_aurora.2.11.3"
component = "mysql"
instance_type_rds = "db.t3.medium"
frontend_app_port = 80
backend_app_port = 8080
app_port = ""
target_group = ""
