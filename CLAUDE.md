# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository is for a Terraform technical test focused on AWS infrastructure provisioning. The project involves implementing multiple AWS services and networking configurations using Infrastructure as Code (IaC) principles.

## Directory Structure

```
terraform-technical-test/
├── environments/                  # Environment-specific configurations
│   └── t-test/                   # Test environment
│       ├── main.tf               # Main configuration
│       ├── variables.tf          # Environment variables
│       ├── outputs.tf            # Environment outputs
│       ├── terraform.tfvars.example
│       └── README.md             # Environment setup guide
├── shared-modules/               # Reusable Terraform modules
│   ├── vpc/                      # VPC module
│   ├── security-groups/          # Security groups module
│   └── ec2/                      # EC2 instances module
├── CLAUDE.md                     # This file
└── REQUIREMENTS.md               # Project requirements
```

## Requirements

The project consists of 5 main tasks as defined in REQUIREMENTS.md:

1. **VPC Setup & Security Groups** - Create VPC with public/private subnets, security groups, and EC2 instances ✅
2. **IAM Roles & Policies** - Set up IAM user, roles, and S3 permissions for EC2
3. **S3 & Object Lifecycle Management** - Create S3 bucket with lifecycle policies
4. **CloudWatch Alarms & Notifications** - Monitor EC2 CPU with SNS notifications
5. **Basic Networking Concepts** - Documentation on networking fundamentals

## Development Commands

Navigate to the environment directory first:
```bash
cd environments/t-test
```

Then use standard Terraform commands:
```bash
terraform init      # Initialize Terraform working directory
terraform plan      # Show execution plan
terraform apply     # Apply changes to infrastructure
terraform destroy   # Destroy managed infrastructure
terraform validate  # Validate configuration syntax
terraform fmt       # Format configuration files
```

## Working with Environments

- Each environment has its own `terraform.tfvars` file
- Modules are shared across environments from `shared-modules/`
- Environment-specific configurations are in `environments/{env-name}/`
- Always work from within the environment directory

## Module Development

- Shared modules are located in `shared-modules/`
- Each module should have `main.tf`, `variables.tf`, and `outputs.tf`
- Modules are referenced with relative paths: `../../shared-modules/module-name`
- Test module changes in the t-test environment first

## Architecture

The infrastructure is organized into reusable modules:

- **VPC Module** - VPC, subnets, routing, NAT/Internet gateways
- **Security Groups Module** - Security groups for public and private access
- **EC2 Module** - EC2 instances with proper configurations
- Future modules: IAM, S3, CloudWatch, SNS

## AWS Services Involved

- **VPC** - Virtual Private Cloud with public/private subnet architecture
- **EC2** - Compute instances with different security configurations
- **IAM** - Identity and Access Management for service permissions
- **S3** - Object storage with lifecycle management
- **CloudWatch** - Monitoring and alerting
- **SNS** - Simple Notification Service for alerts

## Key Considerations

- Use environment-specific variable files
- Ensure proper subnet CIDR allocation for public and private subnets
- Configure NAT Gateway for private subnet internet access
- Implement least-privilege IAM policies
- Use appropriate instance types and AMIs for EC2
- Set up proper security group rules for SSH and HTTP access
- Configure lifecycle transitions for cost optimization
- Tag all resources consistently with environment information