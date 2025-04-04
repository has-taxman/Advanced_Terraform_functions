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
# Dynamic blocks
#################################################################################


variable "ports" {
  type = list(number)
  default = [22, 80, 443]
}

# Build a list of objects from the ports, each with:
# - from_port, to_port, protocol, and a description (based on the port)

locals {
  ingress_rules = [
    for p in var.ports : {
      description = p == 22 ? "SSH" : p == 80 ? "HTTP" : p == 443 ? "HTTPS" : "Other"
      from_port   = p
      to_port     = p
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] 
    }
  ]
}

resource "aws_security_group" "dynamic_sg" {
  name        = "dynamic-block-sg"
  description = "Security Group using dynamic blocks"
  vpc_id      = "vpc-1234565" # LocalStack wont validate this

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = ingress.value.description
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}



# A dynamic block in Terraform allows you to create multiple nested configurations inside a resource dynamically based on a list or map. 
# This is useful when you need to generate multiple similar configurations without duplicating code.