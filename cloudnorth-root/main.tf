terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Local values
locals {
  name_prefix = "cloudnorth"
  tags = {
    Project     = "CloudNorth"
    Environment = "dev"
    Terraform   = "true"
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}

# EC2 Module
module "ec2" {
  source = "./modules/ec2"

  vpc_id           = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  # Remove s3_bucket_name reference
}

# S3 Module
module "s3" {
  source = "./modules/s3"

  bucket_name = var.s3_bucket_name
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  ec2_security_group_ids = [module.ec2.ec2_sg_id]  # This should now work
  db_instance_class      = var.db_instance_class
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  engine_version         = "8.0" 
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  private_subnet_ids = module.vpc.private_subnet_ids
  cluster_name       = var.cluster_name
  jenkins_role_arn   = module.jenkins[0].jenkins_iam_role_arn
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn  = var.certificate_arn
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"

  ec2_instance_ids = [module.ec2.frontend_instance_id, module.ec2.backend_instance_id]
  rds_instance_id  = "cloudnorth-db" # RDS identifier
  alert_email      = var.alert_email
  aws_region       = var.aws_region
  monthly_budget   = var.monthly_budget
}

# Jenkins CI/CD Server
module "jenkins" {
  count = var.enable_jenkins ? 1 : 0
  
  source = "./modules/jenkins"

  name_prefix       = "cloudnorth"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_ids[0]  # Use the correct output name
  instance_type     = var.jenkins_instance_type
  key_name          = "cloudnorth-keypair"  # Hardcode since we know the name from EC2 module
  region           = var.aws_region  # Changed from var.region to var.aws_region
  s3_bucket_name   = var.s3_bucket_name  # Use variable directly since module.s3 might not exist yet
  volume_size      = var.jenkins_volume_size

  ssh_cidr_blocks = var.jenkins_ssh_cidr_blocks
  web_cidr_blocks = var.jenkins_web_cidr_blocks

  tags = {
    Project     = "CloudNorth"
    Environment = "dev"
    Terraform   = "true"
  }

  depends_on = [module.vpc, module.ec2]
}
