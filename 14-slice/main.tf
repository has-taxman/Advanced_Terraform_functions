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
# Slice
#################################################################################


variable "my_list" {
  type = list(string)
  default = ["apple", "banana", "cherry", "date", "elderberry"]
}

locals {
  first_two = slice(var.my_list, 0, 2) # ["apple", "banana"]
  middle = slice(var.my_list, 1, 4) # ["banana", "cherry" ,"date"]

  # Convert lists to strings for triggers
  first_two_str = join(", ", local.first_two) 
  middle_str    = join(", ", local.middle)
}

resource "null_resource" "slice_example" {
  triggers = {
    first_two = local.first_two_str
    middle    = local.middle_str
  }
}
