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
# Merge
#################################################################################

variable "environment" {
  type    = string
  default = "dev"
}

locals {
  default_tags = {
    CreatedBy = "Terraform"
    Department = "Engineering"
  }
}

variable "env_tags" {
  type = map(string)
  default = {
    Env = "dev"
    Tier = "sandbox"
  }
}

resource "aws_instance" "merged_tags_example" {
  ami = "ami-test"
  instance_type = "t2.micro"

  tags = merge(
    local.default_tags,
    var.env_tags,
    {
      Name = "merged-tags-${var.environment}"
    }
  )
}

# The merge function in Terraform combines multiple maps into a single map.
# If two maps have the same key, the last one overwrites the previous ones.