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
# Conditionals
#################################################################################

#################################################################################
# Example 1 - Simple Ternary for Instance Type
#################################################################################

# variable "environment" {
#   type    = string
# #  default = "dev"
# }

# resource "aws_instance" "conditional_instance" {
#   ami = "ami-test"

#   # If environment = "prod", use t3.large, else t2.micro
#   instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"

#   tags = {
#     Name = "conditional-instance-${var.environment}"
#     }
# }
# terraform apply -var="environment=prod"
# terraform apply -var="environment=dev"

#################################################################################
# Example 2 - Conditional resource creation
#################################################################################

# variable "environment" {
#   type    = string
#   default = "dev"
# }

# resource "aws_instance" "main" {
#   ami           = "ami-test"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "main-instance"
#     }
# }

# resource "aws_eip" "optional_eip" {
#   count = var.environment == "prod" ? 1 : 0
#   instance = aws_instance.main.id
  
#   # Tag it for reference
#   tags = {
#     Name = "conditional-eip"
#     }
# }
# terraform plan -var="environment=prod"
# terraform plan -var="environment=dev"

#################################################################################
# Example 3 - Conditional logic in locals
#################################################################################

# variable "is_high_priority" {
#   type    = bool
#   default = false
# }

# locals {
#   selected_type = var.is_high_priority ? "t3.large" : "t2.micro"

#   # If it's high priority, let's add a special tag
#   extra_tags = var.is_high_priority ? { Priority = "High" }  : {}
# }
# resource "aws_instance" "local_conditional" {
#   ami           = "ami-test"
#   instance_type = local.selected_type
#   tags = merge(
#     {
#       Name = "local-conditional"
#     },
#     local.extra_tags
#   )
# }

# # terraform plan -var="is_high_priority=true"
# # terraform plan -var="is_high_priority=false"

#################################################################################
# Example 4 - Conditional expressions in a dynamic block
#################################################################################

# variable "enable_ssh" {
#   type    = bool
#   default = false
# }

# resource "aws_security_group" "dynamic_rules" {
#   name        = "conditional-sg"
#   description = "Example security group with optional SSH"
#   vpc_id = "vpc-123456" # localstack ignores this, but we must define something

#   # Always create a rule for HTTP
#   ingress {
#     description = "HTTP"
#     from_port  = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   # Conditionally creat an SSH rule
#   dynamic "ingress" {
#     for_each = var.enable_ssh ? [1] : []
#     content {
#       description = "SSH"
#       from_port = 22
#       to_port = 22
#       protocol = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# } 
# # terraform plan -var="is_high_priority=true"
# # terraform plan -var="is_high_priority=false"

#################################################################################
# Example 5 - Combining Conditional
#################################################################################

variable "environment" {
  type    = string
  default = "dev"
}

variable "is_high_priority" {
  type    = bool
  default = false
}

resource "aws_instance" "combo_instance" {
  count = var.environment == "prod" ? (var.is_high_priority ? 3 : 2) : 1
  ami           = "ami-test"
  instance_type = "t2.micro"
  tags = {
    Name = "combo-instance-${count.index}"
    Environment = var.environment
    HighPriority = var.is_high_priority ? "yes" : "no"
  }
} 

# Default "terraform plan" will create 1 instance  
# terraform plan -var="environment=prod" => will create 2 instances
# terraform plan -var="environment=prod" -var="is_high_priority=true" => count=3