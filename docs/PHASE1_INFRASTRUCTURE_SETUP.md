## 🔷 Phase 1 — Building CloudNorth’s AWS Infrastructure (IaC using Terraform)

This phase laid the entire foundation of the CloudNorth platform—networking, compute, storage, security, container orchestration, and DevOps tooling. Everything was automated using Terraform, ensuring repeatability and scalability.

### 1. VPC & Networking

I designed and deployed a production-ready VPC:

1 VPC: vpc-095e5bff94ed38ef6

4 subnets

2 Public

2 Private

Internet Gateway

NAT Gateway

Route tables (public/private)

This network was architected such that:

EC2 frontend lives in a public subnet

Backend servers, RDS, and EKS nodes live in private subnets

Only the ALB exposes public traffic

NAT provides secure outbound internet for EKS + backend

### 2. EC2 Compute Layer
Frontend Server — Public

Server IP: 52.90.85.2

Hosts initial frontend build (later replaced by EKS)

Backend Server — Private

Server IP: 10.0.3.197

Private API server for internal access only

Later, both servers were replaced by Kubernetes workloads.

### 3. Storage Layer (S3 + RDS)
S3 Bucket

cloudnorth-static-assets-2025

Hosts frontend assets (images, CSS, JS)

Reduces container size

Better performance via S3 caching

RDS Database

Fully provisioned using Terraform:

Multi-AZ ready

Security groups restricted to backend/EKS

Automated backups enabled

### 4. Load Balancing

Provisioned an Application Load Balancer (ALB):

cloudnorth-alb-1784847908.us-east-1.elb.amazonaws.com


Purpose:

Serve frontend traffic

Route backend API calls

Later acts as EKS Ingress load balancer

### 5. EKS Kubernetes Cluster

EKS cluster deployed via Terraform:

Cluster Name: cloudnorth-cluster

Version: 1.28

Node Groups:

2 × t3.medium

IAM Roles:

Cluster role

Node role

Correct AWS policies attached

Challenge:

The cluster originally failed authentication because:

Jenkins role wasn’t added to the aws-auth ConfigMap

EndpointPrivateAccess was preventing connection

Fix Implemented:

Regenerated aws-auth YAML

Added worker & Jenkins IAM roles

Updated cluster endpoint access

Rebuilt EKS using Terraform

Validated nodes:

kubectl get nodes


Output:

ip-10-0-3-219.ec2.internal   Ready
ip-10-0-4-234.ec2.internal   Ready


EKS became fully operational.

### 6. Monitoring + Alerts

Implemented AWS monitoring stack:

CloudWatch dashboards (EC2, RDS, EKS)

CloudWatch alarms (CPU, storage)

SNS alerts → Email notifications

### 7. Jenkins Automation Server

A production Jenkins environment was deployed:

Secure IAM instance profile

Installed AWS CLI, kubectl, Docker, Node.js

Integrated with GitHub

Configured Jenkins pipelines for CI/CD

Granted EKS cluster access

The Jenkins node was later rebuilt completely using a fresh AMI after Node.js dependency conflicts.

##🚀 Technical Implementation Notes

🔧 Challenges Overcome

Like any engineering journey, we encountered some challenges that made us smarter:

SSL Certificate Dependency

Problem: HTTPS listener required certificate

Solution: Implemented conditional creation - HTTPS only when certificate available

Result: ALB deploys successfully with HTTP, ready for HTTPS upgrade

EKS IAM Complexity

Problem: Multiple IAM roles needed for EKS

Solution: Structured IAM roles with least privilege

Result: Secure cluster with proper permissions

Module Dependencies

Problem: Modules couldn't be applied independently

Solution: Clear documentation on root-level application

Result: Smooth deployment process

📈 Scalability Metrics

EKS Cluster: 2→3 node auto-scaling

ALB Capacity: Handles 1000s of concurrent connections

RDS Instance: Scalable storage and compute

S3 Bucket: Unlimited object storage


