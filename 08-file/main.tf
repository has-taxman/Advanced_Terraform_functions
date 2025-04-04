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
# File
#################################################################################

variable "userdata_file" {
  type = string
  default = "user_data.sh"
}

  resource "aws_instance" "file_example" {
    ami = "ami-test"
    instance_type = "t2.micro"

    # We read the file contents and pass them in as user_data
    user_data = file(var.userdata_file)

    tags = {
      Name = "file-example"
    }
}
