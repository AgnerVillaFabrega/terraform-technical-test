# T-Test Environment

This directory contains the Terraform configuration for the t-test environment.

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform >= 1.0 installed
3. SSH key pair created (or use existing one)

## Setup

1. Copy the example tfvars file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your specific values:
   - Update `key_name` to match your EC2 key pair
   - Modify regions/AZs if needed
   - Adjust CIDR blocks if required

3. Generate SSH key pair if needed:
   ```bash
   ssh-keygen -t rsa -b 2048 -f ~/.ssh/terraform-t-test-key
   aws ec2 import-key-pair --key-name terraform-t-test-key --public-key-material fileb://~/.ssh/terraform-t-test-key.pub
   ```

## Deployment

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# To destroy resources
terraform destroy
```

## Resources Created

- VPC with 2 public and 2 private subnets
- Internet Gateway and NAT Gateways
- Security Groups for public and private access
- 2 EC2 instances (one public, one private)
- Route tables and associations

## Testing Connectivity

After deployment, you can test connectivity between instances:

1. SSH to public instance:
   ```bash
   ssh -i ~/.ssh/terraform-t-test-key ec2-user@<public-ip>
   ```

2. From public instance, SSH to private instance:
   ```bash
   ssh -i ~/.ssh/terraform-t-test-key ec2-user@<private-ip>
   ```