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
# Can
#################################################################################

# Let's imagine we have a variable that may or may not be valid JSON

variable "possible_json" {
  type = string
  # default = {\"key\":\"value\"} # could be invalid
}

locals {
  decode_ok = can(jsondecode(var.possible_json))
  # Returns true if jsondecode succeeds, otherwise false.
  final_value = local.decode_ok ? "Valid JSON" : "Oops, invalid JSON, falling back."
}

resource "null_resource" "can_example" {
  triggers = {
    outcome = local.final_value
  }
}

# terraform plan -var='possible_json={"key":"value"}' # see "Valid JSON!"
# terraform plan -var='possible_json=notjson' # see "Oops, invalid JSON ... "