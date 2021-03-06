# input.tf
variable "project_name" {}
variable "environment_name" {}

variable "enable_dns_hostnames" {
  default = "false"
}

variable "vpc_cidr" {}

variable "vpc_public_subnet_cidrs" {
  type = list
}

variable "vpc_private_subnet_cidrs" {
  type = list
}

variable "azs" {
  type = list
}
