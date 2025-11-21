output "frontend_instance_id" {
  description = "Frontend EC2 instance ID"
  value       = aws_instance.frontend.id
}

output "backend_instance_id" {
  description = "Backend EC2 instance ID"
  value       = aws_instance.backend.id
}

output "frontend_public_ip" {
  description = "Frontend EC2 public IP"
  value       = aws_instance.frontend.public_ip
}

output "backend_private_ip" {
  description = "Backend EC2 private IP"
  value       = aws_instance.backend.private_ip
}

output "key_pair_name" {
  description = "Key pair name"
  value       = aws_key_pair.cloudnorth_kp.key_name
}

output "private_key" {
  description = "Private key content"
  value       = tls_private_key.cloudnorth_key.private_key_pem
  sensitive   = true
}

output "ec2_sg_id" {
  description = "EC2 security group ID"
  value       = aws_security_group.ec2_sg.id
}
