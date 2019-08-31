# vpc.tf
# Module to create the VPC
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags = {
    Name = "${format("%s-%s", var.project_name, var.environment_name)}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${format("%s-%s-igw", var.project_name, var.environment_name)}"
  }
}

# Create an route table for outbound intenet traffic and attach it to the public 
# subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "${format("%s-%s-pub-rt", var.project_name, var.environment_name)}"
  }
}

resource "aws_route_table_association" "route_association" {
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
  count          = "${length(var.vpc_public_subnet_cidrs)}"
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.vpc_private_subnet_cidrs[count.index]}"
  availability_zone = "${var.azs[count.index]}"
  count             = "${length(var.vpc_private_subnet_cidrs)}"

  tags = {
    Name = "${format("%s-%s-pri-sub%d", var.project_name, var.environment_name, count.index)}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.vpc_public_subnet_cidrs[count.index]}"
  availability_zone = "${var.azs[count.index]}"
  count             = "${length(var.vpc_public_subnet_cidrs)}"

  tags = {
    Name = "${format("%s-%s-pub-sub%d", var.project_name, var.environment_name, count.index)}"
  }
}

# Have the default security group allow ssh inbound
resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
