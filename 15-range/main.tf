terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"
        }
    }

    required_version = ">= 1.0"
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test" 
  region                      = "us-east-1"  # Change as needed
  skip_credentials_validation = true
  skip_requesting_account_id  = true

    endpoints {
    ec2 = "http://localhost:4566"  # LocalStack EC2 endpoint
  }
}

#################################################################################
# Range
#################################################################################


variable "num_instances" {
  type = number
  default = 3
}

locals {
  indices = range(0, var.num_instances)
  # e.g. [0,1,2] if num_instaces=3
}

resource "aws_instance" "range_example" {
  for_each = {
    for i in local.indices : i => i
}

  ami           = "ami-test"
  instance_type = "t2.micro"

  tags = {
    Name = "range-instance-${each.key}"
  }
}