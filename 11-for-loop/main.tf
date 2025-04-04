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
# For loop
#################################################################################

variable "regions" {
  type = list(string)
  default = ["us-east-1", "us-west-2", "eu-central-1"]
}

locals {
  # Transform each region into "region-dev"
  dev_regions = [for r in var.regions : "${r}-dev"]
}
  resource "null_resource" "for_expressions" {
    triggers = {
      all_devs = join(",", local.dev_regions)
    }
}
