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

resource "aws_instance" "example" {
  count         = 2
  ami           = "ami-test"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance-${count.index}"
  }
}