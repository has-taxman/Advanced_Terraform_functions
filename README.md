# Terraform HCL Functions, Expressions & Loops

This repository demonstrates key **HCL (HashiCorp Configuration Language) functions, expressions, and loops** in Terraform. It includes examples of **dynamic blocks, for_each loops, conditional expressions, jsondecode, merge, and more**.

## 🚀 Getting Started
To run the Terraform examples in this repository, you'll first need to set up **LocalStack** (a fully functional AWS cloud emulator for local development).

### **1️⃣ Install LocalStack**
Ensure you have **Docker** installed, then install LocalStack via pip:
```sh
pip install localstack
```

Or using Homebrew (for macOS users):
```sh
brew install localstack
```

### **2️⃣ Start LocalStack**
localstack start -d

This will start LocalStack in detached mode.

### **3️⃣ Set AWS CLI to Use LocalStack**
Run the following commands to configure AWS CLI for LocalStack:
```sh
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566
```
### **🏗️ Terraform Features in This Repository**

This repository includes examples showcasing:

🔹 Dynamic Blocks
Demonstrates how to create multiple similar resources dynamically (e.g., security group rules).

🔹 for_each & count Loops
Example of creating multiple EC2 instances using for_each.

🔹 Conditional Expressions
Usage of ternary (? :) expressions in resource configurations.

🔹 jsondecode & merge Functions
Decoding JSON data within Terraform and merging multiple maps.

🔹 External Data Sources
Fetching external JSON data and processing it in Terraform.

### **🛠️ Running Terraform**
Ensure Terraform is installed. Then:
```sh
terraform init
terraform plan
terraform apply
```
To destroy resources:
```sh
terraform destroy
```
### **📌 Notes*
LocalStack emulates AWS services locally, so no real AWS infrastructure is created.

The examples are for educational purposes and may require modifications to work in actual AWS environments.

Feel free to explore and modify the examples! 🚀
