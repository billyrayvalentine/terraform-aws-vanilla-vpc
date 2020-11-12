# terraform-aws-vanilla-vpc
A simple Terraform stack which builds a vanilla public-private VPC

It is useful for quickly spinning up isolated environment

Requires terraform >=0.13

# Usage
* Edit [environments/devtest/terraform.tfvars](environments/devtest/terraform.tfvars)
using the parameters detailed below.
The default values will work as-is.
* Create an S3 bucket in AWS with a name matching the config in
[environments/devtest/main.tf](environments/devtest/main.tf) or remove the S3 back end config

## terraform.tfvars values
| Parameter name           | Example value                    | Notes                                                                                       |
|--------------------------|----------------------------------|---------------------------------------------------------------------------------------------|
| project_name             | projectx                         | components are named ${project_name}-${environment_name}-<component> e.g. projectx-prodcution-pri-sub1                        |
| environment_name         | devtest                          |                                                                                             |
| enable_dns_hostnames     | true                             | Enable DNS support as # https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-dns.html |
| aws_region               | eu-west-2                        | https://docs.aws.amazon.com/general/latest/gr/rande.html                                    |
| azs                      | ["eu-west-2a", "eu-west-2b", "eu-west-2c"]     | list of availability zones to deploy subnets into                                           |
| vpc_cidr                 | 10.10.0.0/20                     | VPC CIDR                                                                                    |
| vpc_public_subnet_cidrs  | ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"] | List of CIDR's for the public subnets.  Length must be the same as 'azs' above              |
| vpc_private_subnet_cidrs | ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24"] | List of CIDR's for the private subnets. Length must be the same as 'azs' above              |


# What gets created
| Component Type             | Component Name (example)     | Notes
|----------------------------|------------------------------|-----------------------------------------------------------------|
| aws_vpc                    | projectx-devtest             |  10.10.0.0/20 enable_dns_hostnames true enable_dns_support true |
| aws_internet_gateway       | projectx-devtest-igw         |                                                                 |
| aws_route_table            | projectx-devtest-pub-rt      | routes 0.0.0.0/0 to Inernet Gateway                             |
| aws_default_security_group | projectx-devtest-default-sg  |                          | Allow all outbound and 22/tcp inbound                           |
| aws_subnet                 | projectx-devtest-pub-sub0    | 10.10.0.0/24 attaches to projectx-devtest-pub-rt                |
| aws_subnet                 | projectx-devtest-pub-sub1    | 10.10.1.0/24 attaches to projectx-devtest-pub-rt                |
| aws_subnet                 | projectx-devtest-pub-sub2    | 10.10.2.0/24 attaches to projectx-devtest-pub-rt                |
| aws_subnet                 | projectx-devtest-pri-sub0    | 10.10.3.0/24 |
| aws_subnet                 | projectx-devtest-pri-sub1    | 10.10.4.0/24 |
| aws_subnet                 | projectx-devtest-pri-sub0    | 10.10.5.0/24 |

# Layout
```
├── environments
│   └── devtest
│       ├── input.tf
│       ├── main.tf
│       └── terraform.tfvars
├── modules
│   └── vpc
│       ├── input.tf
│       ├── output.tf
│       └── vpc.tf
└── README.md
```
