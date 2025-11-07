# 🛍️ CloudNorth E-commerce Platform

A modern, scalable e-commerce platform built with cloud-native technologies. This project demonstrates full-stack development with infrastructure as code, container orchestration, and professional DevOps practices.

## 🎯 Project Phases

### ✅ Phase 1: Cloud Infrastructure (Complete)
**Infrastructure as Code with AWS and Terraform**

#### 🏗️ Architecture Deployed:
Internet → ALB → EKS Cluster → Microservices → RDS
↓
S3 Static Assets

text

#### 📦 Infrastructure Components:
- **VPC Network**: Custom VPC with public and private subnets across multiple AZs
- **Compute**: 
  - Frontend EC2 instance (Ubuntu with Apache) - Public subnet
  - Backend EC2 instance - Private subnet
  - EKS Kubernetes cluster with 2 worker nodes (auto-scaling 1-3 nodes)
- **Data Layer**:
  - RDS MySQL database in private subnet
  - S3 bucket for static assets with versioning
- **Networking**:
  - Application Load Balancer (ALB) with HTTP/HTTPS listeners
  - NAT Gateway for private subnet internet access
  - Security groups with least-privilege access
- **Monitoring**:
  - CloudWatch dashboard for infrastructure metrics
  - SNS alerts for critical issues
  - Budget monitoring and alerts

#### 🔧 Technologies Used:
- **Terraform**: Infrastructure as Code
- **AWS**: EC2, EKS, RDS, S3, ALB, VPC, CloudWatch
- **Modular Design**: Reusable Terraform modules

#### 🌐 Live Endpoints:
- Frontend: http://54.196.1.117
- ALB: http://cloudnorth-alb-1784847908.us-east-1.elb.amazonaws.com

### ✅ Phase 2: Source Code Management (Complete)
**Professional Git Workflow and Team Collaboration**

#### 📁 Repository Structure:
cloudnorth-platform/
├── frontend/ # Next.js React application
├── backend/ # Node.js Express API
├── infrastructure/ # Terraform, Docker, DevOps scripts
├── .github/ # PR templates & workflow definitions
├── docs/ # Project documentation
├── README.md # This file
├── CONTRIBUTING.md # Development guidelines
└── LICENSE # MIT License

text

#### 🔒 Git Workflow Established:
- **Branch Strategy**: main (production) ← dev (development) ← feature/* (work)
- **Branch Protection**: PR requirements, conversation resolution, no bypassing
- **Code Review**: Self-review process for solo development
- **PR Templates**: Standardized pull request format

#### 📋 Development Practices:
- **Commit Convention**: feat/fix/docs/style/refactor/test/chore
- **Documentation**: Comprehensive CONTRIBUTING.md
- **Quality Gates**: Branch protection enforcing PR workflow
- **Professional Habits**: Solo developer discipline

### 🔄 Phase 3: Containerization & CI/CD (Next)
**Docker, GitHub Actions, and Automated Deployment**

#### Planned Components:
- 🐳 Docker containers for frontend and backend
- ⚙️ GitHub Actions workflows
- 📦 Container registry (ECR)
- 🔄 CI/CD pipeline to EKS
- ✅ Automated testing

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Python 3.9+
- Docker & Docker Compose
- AWS CLI configured
- Terraform 1.0+

### Development Setup
```bash
# Clone and setup
git clone https://github.com/Bettymusari/cloudnorth-platform.git
cd cloudnorth-platform
git checkout dev

# Install dependencies
cd frontend && npm install
cd ../backend && npm install
Infrastructure Deployment
bash
cd infrastructure/terraform
terraform init
terraform plan
terraform apply
🛠️ Technology Stack
Frontend
Framework: Next.js 14 with React 18

Styling: Tailwind CSS

State Management: Zustand

Testing: Jest + React Testing Library

Backend
Runtime: Node.js with Express

Database: AWS RDS MySQL

Authentication: JWT

Testing: Jest + Supertest

Infrastructure & DevOps
Cloud: AWS

IaC: Terraform (modular design)

Containers: Docker + EKS

CI/CD: GitHub Actions

Monitoring: CloudWatch + SNS

👥 Development Workflow
Branch Strategy
main - Production-ready code (protected)

dev - Development and integration (protected)

feature/* - Feature development

hotfix/* - Production fixes

PR Process
Create feature branch from dev

Make changes and test

Push and create PR to dev

Code review (self-review for solo development)

Merge after approval

Delete feature branch

🏗️ Architecture Details
Cloud Infrastructure
Multi-AZ Deployment: High availability across availability zones

Security: Private subnets for databases, security groups with minimal access

Scalability: EKS auto-scaling, ALB load distribution

Monitoring: Real-time metrics and alerting

Application Architecture
Microservices Ready: EKS cluster prepared for containerized services

API-First Design: Backend API with frontend consumer

Static Assets: S3 with CloudFront-ready structure

Database: RDS with private subnet security

📚 Documentation
Contributing Guide - Development workflow and standards

Infrastructure Docs - Terraform modules and AWS setup

API Documentation - Backend API specifications

🤝 Contributing
We welcome contributions! Please read our Contributing Guide before submitting pull requests.

Development Process
Fork the repository

Create a feature branch (git checkout -b feature/amazing-feature)

Commit your changes (git commit -m 'Add amazing feature')

Push to the branch (git push origin feature/amazing-feature)

Open a Pull Request

📞 Support
GitHub Issues: Report bugs or request features

Documentation: Check the /docs directory

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

🙏 Acknowledgments
AWS for cloud infrastructure

HashiCorp for Terraform

The open-source community
