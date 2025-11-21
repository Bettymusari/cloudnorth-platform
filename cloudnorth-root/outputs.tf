
# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

# EC2 Outputs
output "frontend_public_ip" {
  description = "Frontend EC2 public IP"
  value       = module.ec2.frontend_public_ip
}

output "backend_private_ip" {
  description = "Backend EC2 private IP"
  value       = module.ec2.backend_private_ip
}

# RDS Outputs
output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.rds_endpoint
  sensitive   = true
}

# S3 Outputs
output "s3_bucket_id" {
  description = "S3 bucket ID for static assets"
  value       = module.s3.bucket_id
}

output "s3_bucket_name" {
  description = "S3 bucket name for static assets"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN for static assets"
  value       = module.s3.bucket_arn
}

output "s3_bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = module.s3.bucket_domain_name
}

# Key Pair Outputs (ONLY ONE SET - KEEPING THE CORRECT ONE)
output "key_pair_name" {
  description = "Name of the created key pair"
  value       = module.ec2.key_pair_name
}

output "private_key" {
  description = "Private key for EC2 instances (SAVE THIS IMMEDIATELY)"
  value       = module.ec2.private_key
  sensitive   = true
}

# EKS Outputs
output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

output "eks_node_group_status" {
  description = "EKS node group status"
  value       = module.eks.node_group_status
}

# ALB Outputs
output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB zone ID"
  value       = module.alb.alb_zone_id
}

output "target_group_arn" {
  description = "Target group ARN for EKS"
  value       = module.alb.target_group_arn
}

# Monitoring Outputs
output "cloudwatch_dashboard_url" {
  description = "URL for CloudWatch dashboard"
  value       = module.monitoring.dashboard_url
}

output "alert_sns_topic" {
  description = "SNS topic for alerts"
  value       = module.monitoring.sns_topic_arn
}

# Jenkins Outputs (conditional)
output "jenkins_public_ip" {
  description = "Jenkins server public IP"
  value       = var.enable_jenkins ? module.jenkins[0].jenkins_public_ip : "Jenkins not enabled"
}

output "jenkins_url" {
  description = "Jenkins web interface URL"
  value       = var.enable_jenkins ? module.jenkins[0].jenkins_url : "Jenkins not enabled"
}

output "jenkins_ssh_command" {
  description = "SSH command to connect to Jenkins"
  value       = var.enable_jenkins ? "ssh -i cloudnorth-key.pem ec2-user@${module.jenkins[0].jenkins_public_ip}" : "Jenkins not enabled"
}

