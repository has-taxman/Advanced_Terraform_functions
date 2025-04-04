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
# Join and Lower/Upper
#################################################################################

variable "words" {
  type = list(string)
  default = ["hello", "world"]
}

locals {
  # Convert each word to uppercase:
  upper_list = [for w in var.words : upper(w)]
  # "HELLO", "WORLD"

  # Join them into a single string seperated by a dash:
  joined_upper = join("-", local.upper_list)
}

  resource "null_resource" "join_example" {
    triggers = {
      result = local.joined_upper
    }
}
