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
# Templatefile
#################################################################################

variable "server_port" {
  type = number
  default = 8080
}

  resource "aws_instance" "templatefile_example" {
    ami = "ami-test"
    instance_type = "t2.micro"

    # Instead of a static user_data file, we can fill in placeholders
    user_data = templatefile("${path.module}/user_data.tpl", {
      port = var.server_port
    })

    tags = {
      Name = "templatefile-example"
    }
}
