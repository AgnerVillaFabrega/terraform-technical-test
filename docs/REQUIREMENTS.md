# Tasks
## 1. *VPC Setup & Security Groups*
- Create a new VPC with two public subnets and two private subnets.
- Configure routing between public and private subnets.
- Create two Security Groups:
  - One for an EC2 instance in the public subnet (allow inbound SSH and HTTP traffic).
  - One for an EC2 instance in the private subnet (allow inbound SSH traffic only from the public subnet).
- Launch two EC2 instances (one in each subnet) and verify connectivity between them.

## 2. *IAM Roles & Policies*
- Create an IAM user with programmatic access.
- Create an IAM role for an EC2 instance with permissions to access Amazon S3.
- Launch an EC2 instance with the IAM role attached and verify its ability to read/write data to an S3 bucket.

## 3. *S3 & Object Lifecycle Management*
- Create an S3 bucket.
- Upload a sample file to the S3 bucket.
- Configure Object Lifecycle Management to automatically transition objects to infrequent access storage after 30 days.

## 4. *CloudWatch Alarms & Notifications*
- Create a CloudWatch alarm to monitor CPU utilization of an EC2 instance.
- Configure the alarm to trigger an SNS notification to an email address.

## 5. *Basic Networking Concepts*
- Explain the difference between public and private IP addresses.
- Describe the purpose of a NAT Gateway.
- Briefly explain the concept of subnetting.
