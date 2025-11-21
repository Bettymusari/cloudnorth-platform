variable "ec2_instance_ids" {
  description = "List of EC2 instance IDs to monitor"
  type        = list(string)
}

variable "rds_instance_id" {
  description = "RDS instance ID to monitor"
  type        = string
}

variable "alert_email" {
  description = "Email address for alert notifications"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "monthly_budget" {
  description = "Monthly budget in USD (0 to disable)"
  type        = number
  default     = 0
}
