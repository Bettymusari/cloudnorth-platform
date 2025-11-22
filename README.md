# 🛍️ CloudNorth E-commerce Platform

A modern, scalable e-commerce platform built with cloud-native technologies.  
This project demonstrates full-stack development, cloud automation, continuous delivery, and production-grade DevOps engineering.

---

## 🎯 Project Phases (Overview)

1️⃣ **Phase 1 — Cloud Infrastructure (AWS + Terraform)**  
2️⃣ **Phase 2 — Source Code Management (Git, Branching, PR Workflow)**  
3️⃣ **Phase 3 — Containerization & CI Pipeline (Docker + Jenkins)**  
4️⃣ **Phase 4 — Application Containerization & Static Assets (Docker + S3)**  
5️⃣ **Phase 5 — Kubernetes Deployment (EKS + Helm + ALB Ingress)**  
6️⃣ **Phase 6 — Full CI/CD Pipeline (Jenkins → ECR → Helm → EKS)**  
7️⃣ **Phase 7 — Monitoring, Dashboards & Blue/Green Readiness**

---

# ✅ **Phase 1: Cloud Infrastructure (Complete)**  
**Infrastructure as Code with AWS and Terraform**

### 🏗️ Architecture Deployed

```mermaid
flowchart LR
Internet --> ALB
ALB --> EKS[(EKS Cluster)]
EKS --> Services[Microservices]
Services --> RDS[(MySQL RDS)]
Services --> S3[(S3 Static Assets)]
📦 Infrastructure Components
VPC Network

Custom VPC with public & private subnets across AZs

Internet Gateway + NAT Gateway

Route tables & associations

Compute

Frontend EC2 instance (Ubuntu + Apache) — public subnet

Backend EC2 instance — private subnet

EKS cluster (1–3 auto-scaling nodes)

Data Layer

RDS MySQL (private subnet)

S3 bucket for static assets (versioned + secure)

Networking

Application Load Balancer (ALB)

HTTP/HTTPS listeners

SGs with least-privilege access

Monitoring

CloudWatch dashboard

Alarms + SNS email alerts

Monthly budget alerting

🌐 Live Endpoints
Frontend: http://54.196.1.117

ALB: http://cloudnorth-alb-1784847908.us-east-1.elb.amazonaws.com

🔧 Technologies Used
Terraform

AWS EC2, EKS, ALB, RDS, S3, CloudWatch

Modular Infrastructure-as-Code design

## ✅ Phase 2: Source Code Management (Complete)
Professional Git Workflow & Team Collaboration

📁 Repository Structure
bash
Copy code
cloudnorth-platform/
├── frontend/          # Next.js React application
├── backend/           # Node.js Express API
├── infrastructure/    # Terraform, scripts, DevOps
├── .github/           # PR templates & workflows
├── docs/              # Architecture docs
├── README.md
├── CONTRIBUTING.md
└── LICENSE
🔐 Git Workflow
main → production (protected)

dev → integration (protected)

feature/* → feature development

📋 Development Practices
Conventional commits

PR reviews (even solo self-review)

PR templates

Code quality & documentation enforced

## ✅ Phase 3: CI Pipeline & Containerization (Complete)
Docker + Jenkins (CI)

🐳 Containerization
Multi-stage Dockerfiles

Node 20 Alpine base images

Frontend + backend containerized

Docker Compose validation in CI

Buildx upgraded for multi-platform builds

⚙️ Jenkins CI Setup
Jenkins running on EC2

GitHub → Jenkins webhook integration

Pipeline stages:

markdown
Copy code
1. Checkout Code
2. Install Dependencies
3. Lint & Test
4. Build Frontend in Node 20 container
5. Build Docker Images
6. Docker Compose Build Validation
🧩 Key Wins
Solved Next.js Node version mismatch

Fixed Docker multi-stage COPY issues

Upgraded Docker Buildx

22 pipeline failures → 1 successful production pipeline

## ✅ Phase 4: Application Containerization & Static Assets
🐳 Production Dockerfiles
Clean multi-stage builds for both services

Optimized output (small image sizes)

Non-root user execution

Ready for ECR pushing

📦 Static Assets (S3)
Frontend assets synced to your S3 bucket:

bash
Copy code
aws s3 sync frontend/public/assets s3://cloudnorth-static-assets-2025
✅ Phase 5: Kubernetes Deployment (EKS + Helm + ALB Ingress)
⚓ What Was Deployed
Backend Deployment + Service

Frontend Deployment + Service

ConfigMaps & Secrets

ALB Ingress

ECR images pulled into pods

ServiceAccount + IAM roles for AWS access

🌐 ALB Ingress Diagram
mermaid
Copy code
flowchart LR
User --> ALB
ALB --> Ingress
Ingress --> FE[Frontend Service]
Ingress --> BE[Backend Service]
FE --> FEpod[(Frontend Pods)]
BE --> BEpod[(Backend Pods)]
📌 Final Result
A real AWS ALB was automatically created

Kubernetes routed traffic correctly

The application became globally reachable

Auto-scaling and rolling updates enabled

## ✅ Phase 6: Full CI/CD Pipeline (Jenkins → ECR → Helm → EKS)
🔄 Automated Deployment Flow
mermaid
Copy code
sequenceDiagram
    GitHub->>Jenkins: New push (pipeline triggers)
    Jenkins->>Docker: Build FE/BE images
    Docker->>ECR: Push images
    Jenkins->>Helm: Update release
    Helm->>EKS: Rolling deployment
    EKS->>ALB: Serve updated app
🚀 Deployments are now:
✔ Automated
✔ Repeatable
✔ Versioned
✔ Zero-downtime (rolling updates)

🔐 ECR Repositories Used (Redacted ID)
REDACTED.dkr.ecr.us-east-1.amazonaws.com/myapp-backend

REDACTED.dkr.ecr.us-east-1.amazonaws.com/myapp-frontend

🧠 Deployment Trigger
Push to main → ECR build → Helm upgrade → EKS rollout

## ✅ Phase 7: Monitoring, Alerting & Blue/Green Readiness
📊 Monitoring Stack
CloudWatch metrics

EC2 + RDS CPU alarms

SNS email alerts

CloudWatch dashboard with graphs

Logging via EKS (kubectl logs + CloudWatch Container Insights if enabled)

🔵🟢 Blue/Green Ready
Because your deployment uses:

Helm

EKS

ALB

Rolling updates

You can switch to Blue/Green by:

Deploying myapp-v2

Assigning new target group

Swapping ALB listener

(Your architecture already supports this with zero redesign.)

🚀 Quick Start
Prerequisites
Node.js 18+

Docker + Compose

AWS CLI

Terraform 1.0+

kubectl + Helm

Development Setup
bash
Copy code
git clone https://github.com/Bettymusari/cloudnorth-platform.git
cd cloudnorth-platform
git checkout dev

cd frontend && npm install
cd ../backend && npm install
Deploy Infra
bash
Copy code
cd infrastructure/terraform
terraform init
terraform plan
terraform apply
👥 Development Workflow
main — production

dev — active development

feature/* — feature branches

###🧱 Architecture Summary
mermaid
Copy code
flowchart TB
subgraph AWS
    VPC --> Subnets
    Subnets --> EC2
    Subnets --> EKS
    EKS --> Pods
    Pods --> RDS
    Pods --> S3
    ALB --> EKS
end
Developer --> GitHub --> Jenkins --> ECR --> EKS
📚 Documentation
CONTRIBUTING.md — workflow guide

Infrastructure docs — Terraform modules

API docs — backend endpoints

🤝 Contributing
PRs welcome.
Follow the CONTRIBUTING.md guidelines.

📞 Support
Open a GitHub Issue

See /docs for more details

📄 License
MIT License.

🙏 Acknowledgments
AWS

HashiCorp

Kubernetes

Jenkins

Docker

Open-source community
