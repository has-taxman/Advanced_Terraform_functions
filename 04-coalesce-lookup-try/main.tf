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
# Coalesce
#################################################################################

#################################################################################
# Default name
#################################################################################


# variable "user_defined_name" {
#   type = string
#   default = "" # or null, if you like
# }

# resource "aws_instance" "my_instance" {
#   ami = "ami-test"
#   instance_type = "t2.micro"

#   # There's no 'name' attribute, so define Name in tags
#   tags = {
#     Name = coalesce(var.user_defined_name, "generic_name")
#   }
# }

# 'terraform plan' with default settig => instance name my-generic-instance-name
# 'terraform plan -var="use_defined_name=CustomName" => instance name CustomName

#################################################################################
# Providing missing values
#################################################################################

data "external" "my_data" {
  program = ["python3", "${path.module}/script.py"]
  
  query = {
    name = "some_api"
  }
}

resource "aws_instance" "my_instance" {
  ami           = "ami-test"
  instance_type = "t2.micro"

  # Instead of name / description at the top level, we put both in tags
  tags = {
    Name        = coalesce(lookup(data.external.my_data.result, "id", "fallback_name"), "fallback_name")
    Description = coalesce(lookup(data.external.my_data.result, "description", "No description available"), "No desription available")
  }
}


#################################################################################
# Prioritising different values
#################################################################################

# Let's say the config.json has a key called "my_setting",
# environment variable has another, or we fall back to a default

variable "environment_settings" {
  type = map(string)
  default = {

  }
}

locals {
  config_file_value = try(
    jsondecode(file("${path.module}/config.json")).my_setting,
    null
  )

  environment_value = lookup(var.environment_settings, "my_settings", null)
}

resource "null_resource" "example_config" {
  triggers = {
    setting_in_use = coalesce(
      local.config_file_value,
      local.environment_value,
      "default_value"
    )
  }
}

# In this example, the setting_in_use is set to the value of the config_file_value, or the  environment_value or the default_value. 
# The one that takes precedent is the first one. 