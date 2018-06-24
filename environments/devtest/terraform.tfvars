# terraform.tfvars

# components are named project_name-environment_name-component
# e.g. projectx-prodcution-pri-sub1
project_name = "projectx"
environment_name = "devtest" 

# https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-dns.html
enable_dns_hostnames = "true"

# Network Addressing
aws_region = "eu-west-2"
azs = ["eu-west-2a", "eu-west-2b"]
vpc_cidr = "10.10.0.0/20" 
vpc_public_subnet_cidrs = ["10.10.0.0/24", "10.10.1.0/24"]
vpc_private_subnet_cidrs = ["10.10.2.0/24", "10.10.3.0/24"]
