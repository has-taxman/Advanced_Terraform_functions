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
# JSON decode
#################################################################################

# variable "raw_json" {
#   type = string
# }

locals {
  raw_content = file("raw.json")  # Read the file separately
  parsed = jsondecode(local.raw_content)
  reencoded = jsonencode({
    original_name = local.parsed.name
    extra_data    = "something"
  })
}
  resource "null_resource" "json_example" {
    triggers = {
      read_name = local.parsed.name
      read_reps = tostring(local.parsed.replicas)
      final_json = local.reencoded
    }
}
# The jsondecode function in Terraform converts a JSON string into a Terraform map, list, or value.