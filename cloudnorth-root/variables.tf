variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0fc5d935ebf8bc3bc"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for static assets"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "cloudnorth"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}


variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "cloudnorth-cluster"
}

variable "certificate_arn" {
  description = "ARN of SSL certificate for ALB HTTPS"
  type        = string
  default     = ""
}

variable "alert_email" {
  description = "Email for monitoring alerts"
  type        = string
  default     = "admin@cloudnorth.com"
}

variable "monthly_budget" {
  description = "Monthly budget in USD (0 to disable budget alerts)"
  type        = number
  default     = 100
}

# Jenkins Variables

variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins server"
  type        = string
  default     = "t3.medium"
}

variable "jenkins_volume_size" {
  description = "Root volume size for Jenkins instance (GB)"
  type        = number
  default     = 20
}

variable "jenkins_ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access to Jenkins"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "jenkins_web_cidr_blocks" {
  description = "CIDR blocks allowed for web access to Jenkins"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_jenkins" {
  description = "Whether to create Jenkins CI/CD server"
  type        = bool
  default     = true
}
