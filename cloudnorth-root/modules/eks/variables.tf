variable "private_subnet_ids" {
  description = "Private subnets for EKS"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "jenkins_role_arn" {
  description = "Jenkins IAM Role ARN"
  type        = string
}
