# main.tf
# Setup S3 and the provider and invoke the vpc module
#terraform {
#  backend "s3" {
#    bucket = "am0iu9ihei"
#    key    = "terraform/terraform-aws-vanilla-vpc.tfstate"
#    region = "eu-west-2"
#  }
#}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                   = "../../modules/vpc"
  project_name             = var.project_name
  environment_name         = var.environment_name
  enable_dns_hostnames     = var.enable_dns_hostnames
  azs                      = var.azs
  vpc_cidr                 = var.vpc_cidr
  vpc_public_subnet_cidrs  = var.vpc_public_subnet_cidrs
  vpc_private_subnet_cidrs = var.vpc_private_subnet_cidrs
}
