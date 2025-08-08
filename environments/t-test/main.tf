terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../shared-modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  
  tags = var.common_tags
}

module "security_groups" {
  source = "../../shared-modules/security-groups"
  
  vpc_id              = module.vpc.vpc_id
  public_subnet_cidr  = var.vpc_cidr
  private_subnet_cidr = var.vpc_cidr
  
  tags = var.common_tags
}

module "ec2" {
  source = "../../shared-modules/ec2"
  
  vpc_id                    = module.vpc.vpc_id
  public_subnet_id          = module.vpc.public_subnet_ids[0]
  private_subnet_id         = module.vpc.private_subnet_ids[0]
  public_security_group_id  = module.security_groups.public_sg_id
  private_security_group_id = module.security_groups.private_sg_id
  key_name                  = var.key_name
  
  tags = var.common_tags
}