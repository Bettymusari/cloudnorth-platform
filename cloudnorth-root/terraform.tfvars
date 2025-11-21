aws_region = "us-east-1"
vpc_cidr   = "10.0.0.0/16"

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

ami_id        = "ami-0fc5d935ebf8bc3bc"
instance_type = "t3.micro"

s3_bucket_name = "cloudnorth-static-assets-2025" # Change to unique name

db_instance_class = "db.t3.micro"
db_name          = "cloudnorth"
db_username      = "admin"
db_password      = " CloudNorth123!" # Change to secure password


# EKS Configuration
cluster_name = "cloudnorth-cluster"

# ALB Configuration (leave empty for now, we'll add SSL cert later)
certificate_arn = ""

# Monitoring Configuration
alert_email    = "opsbabs3@gmail.com"  # Change to your email
monthly_budget = 100  # $100 monthly budget alert

# Jenkins Configuration
jenkins_instance_type    = "t3.medium"
jenkins_volume_size      = 20
jenkins_ssh_cidr_blocks  = ["0.0.0.0/0"]
jenkins_web_cidr_blocks  = ["0.0.0.0/0"]
enable_jenkins           = true
