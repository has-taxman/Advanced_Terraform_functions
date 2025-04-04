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
# Concatenation
#################################################################################

locals {
  list_one = ["dev", "test"]
  list_two = ["prod", "staging"]

  merged_list = concat(local.list_one, local.list_two)
  }

  resource "null_resource" "concat_example" {
    triggers = {
      all_envs = join(",", local.merged_list)
    }
  }