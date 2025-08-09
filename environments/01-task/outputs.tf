output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "public_ec2_public_ip" {
  description = "Public IP of the EC2 instance in public subnet"
  value       = module.ec2.public_ec2_public_ip
}

output "private_ec2_private_ip" {
  description = "Private IP of the EC2 instance in private subnet"
  value       = module.ec2.private_ec2_private_ip
}

output "public_security_group_id" {
  description = "ID of the public security group"
  value       = module.security_groups.public_sg_id
}

output "private_security_group_id" {
  description = "ID of the private security group"
  value       = module.security_groups.private_sg_id
}