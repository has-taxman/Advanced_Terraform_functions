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

locals {
  instances = {
    dev1 = {
      instance_type = "t2.micro"
      ami_id        = "ami-dev1" 
    }

    dev2 = {
      instance_type = "t2.micro"
      ami_id        = "ami-dev2"
    } 

    dev3 = {
      instance_type = "t3.micro"
      ami_id        = "ami-dev3"
    }
  }
}

resource "aws_instance" "this" {
  for_each = local.instances
  
  ami           = each.value.ami_id 
  instance_type = each.value.instance_type

  tags = {
    Name = each.key
  }
}
