🛍️ CloudNorth E-Commerce Platform

A fully cloud-native, production-grade e-commerce deployment showcasing Infrastructure as Code, Kubernetes, CI/CD automation, containerization, and observability — designed and implemented end-to-end by Betty Musari.

This project demonstrates real-world DevOps engineering: building, deploying, scaling, automating, and monitoring a complete platform on AWS.

🔥 Project Overview

CloudNorth is a full DevOps simulation taking an e-commerce platform from local code → cloud infrastructure → automated CI/CD → Kubernetes deployment → monitoring.

It is built in 7 professional DevOps phases:

Phase	Description	Status
1	AWS infrastructure (VPC, EC2, EKS, RDS, ALB, S3) with Terraform	✅ Done
2	Professional GitHub repository + branching workflow	✅ Done
3	Jenkins installation, container agents & CI pipeline	✅ Done
4	Full App Containerization (Dockerfiles, Compose)	✅ Done
5	EKS Deployment with Helm + ALB Controller	✅ Done
6	Automated CI/CD (Jenkins → ECR → Helm → EKS)	✅ Done
7	Monitoring, Logging, Alerts, Blue/Green Deployments	✅ Done
🏗️ PHASE 1 — Cloud Infrastructure (AWS + Terraform)

CloudNorth runs on a fully automated AWS foundation using Terraform modules.

🌐 High-Level Architecture
flowchart TD
    User --> ALB["Application Load Balancer"]
    ALB --> EKS["EKS Cluster"]
    EKS --> FE["Frontend Pod"]
    EKS --> BE["Backend Pod"]
    BE --> RDS["Amazon RDS MySQL"]
    FE --> S3["S3 Static Assets"]

✔️ Components Deployed

VPC with 2 public + 2 private subnets

EKS cluster (1.28) with managed node group

ALB for traffic routing

EC2 instances (frontend & backend experimental nodes)

RDS MySQL in private subnet

S3 Bucket for static assets

CloudWatch Dashboards + SNS Alerts

NAT Gateway + IGW

Security groups with least-privilege rules

Live Endpoints

Frontend: http://54.196.1.117

ALB: (Redacted for privacy — visible in AWS console)

🔐 PHASE 2 — Source Code Management (GitHub Workflow)

A professional software-engineering workflow was established.

📁 Final Repository Structure
cloudnorth-platform/
├── backend/          # Node.js Express API
├── frontend/         # Next.js 14 Web App
├── infrastructure/   # Terraform + DevOps scripts
├── myapp-chart/      # Helm charts for Kubernetes
├── .github/          # PR templates & workflows
├── docs/             # Architecture diagrams, guides
└── README.md

🎯 Git Workflow

main → Production

dev → Integration environment

feature/* → New features

fix/* → Bug fixes

Protections Enabled

Required Pull Requests

Required conversation resolution

No direct commits to main/dev

🐳 PHASE 3 — Jenkins CI Pipeline (Build & Test)

Jenkins was deployed on EC2 and integrated with:

GitHub Webhooks

Docker Engine

Kubernetes CLI

ECR authentication

Jenkins inbound-agent (Docker)

A full CI pipeline executes:

Checkout

Backend build & lint

Frontend build inside Node 20 container

Docker Compose build test

Artifact verification

📦 PHASE 4 — Full Application Containerization

Both services were containerized using multi-stage Dockerfiles.

Frontend Dockerfile Highlights

Node 20 base image

Production build

Runs with Next.js server (port 3000)

Backend Dockerfile

Node 20

Express API on port 8080

Production dependencies only

Local Test
docker compose build
docker compose up

☸️ PHASE 5 — Kubernetes (EKS) Deployment Using Helm

A complete Helm chart was written:

myapp-chart/
├── templates/
│   ├── deployment-frontend.yaml
│   ├── deployment-backend.yaml
│   ├── service-frontend.yaml
│   ├── service-backend.yaml
│   ├── ingress.yaml
│   ├── configmap.yaml
│   └── secrets.yaml
└── values.yaml

AWS Load Balancer Controller

Installed & configured to allow Kubernetes to dynamically create ALBs.

Deployment
helm upgrade --install myapp ./myapp-chart -n myapp
kubectl get ingress -n myapp

Result

Kubernetes generated a real AWS ALB with DNS exposed to the internet.

🔁 PHASE 6 — Full CI/CD (Jenkins → ECR → Helm → EKS)

Here is the actual CI/CD flow:

sequenceDiagram
    participant Dev as Developer
    participant GitHub
    participant Jenkins
    participant ECR
    participant Helm
    participant EKS

    Dev->>GitHub: Push Code
    GitHub->>Jenkins: Webhook Trigger
    Jenkins->>Jenkins: Build Docker Images
    Jenkins->>ECR: Push Images
    Jenkins->>Helm: Update Release
    Helm->>EKS: Rolling Deployment
    EKS->>Dev: New Version Live

What Jenkins Automates

Build images

Tag as latest

Push to ECR

Set KUBECONFIG

Run helm upgrade

Trigger rolling update in EKS

Jenkinsfile (clean & final)
pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-east-1"
        ECR_BACKEND = "REDACTED.dkr.ecr.us-east-1.amazonaws.com/myapp-backend"
        ECR_FRONTEND = "REDACTED.dkr.ecr.us-east-1.amazonaws.com/myapp-frontend"
    }

    stages {
        stage('Checkout Code') {
            steps { checkout scm }
        }

        stage('Build Backend Image') {
            steps {
                sh """
                cd backend
                docker build -t myapp-backend .
                docker tag myapp-backend:latest $ECR_BACKEND:latest
                """
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh """
                cd frontend
                docker build -t myapp-frontend .
                docker tag myapp-frontend:latest $ECR_FRONTEND:latest
                """
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region us-east-1 |
                docker login --username AWS --password-stdin $ECR_BACKEND
                """
            }
        }

        stage('Push Images') {
            steps {
                sh """
                docker push $ECR_BACKEND:latest
                docker push $ECR_FRONTEND:latest
                """
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                export KUBECONFIG=/var/lib/jenkins/kubeconfig
                helm upgrade --install myapp ./myapp-chart -n myapp
                """
            }
        }
    }
}

📡 PHASE 7 — Monitoring, Logging & Blue/Green Deployments

Phase 7 ensured CloudNorth is observable, reliable, and resilient.

📊 Monitoring Stack

CloudWatch Dashboards (CPU, Memory, ALB, EKS)

SNS Alerts (High CPU, Pod CrashLoop, Budget)

EKS Cluster Logging → CloudWatch

🔵🟢 Blue/Green Deployments

Achieved using Helm strategies:

strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0


For frontend + backend:

new pods spin up

health checks validate

traffic shifts only after success

This ensures zero downtime deployments.

🧪 Quick Start for Developers
git clone https://github.com/Bettymusari/cloudnorth-platform.git
cd cloudnorth-platform

cd frontend && npm install
cd backend && npm install


Infrastructure:

cd infrastructure/terraform
terraform init
terraform apply


Local containers:

docker compose up --build

🧱 Tech Stack
Frontend

Next.js 14

React 18

Tailwind

Zustand

Jest

Backend

Node.js + Express

MySQL (RDS)

JWT Auth

Jest + Supertest

DevOps

Terraform

AWS (RDS, ALB, EKS, EC2, S3)

Jenkins CI/CD

ECR

Helm

Kubernetes

CloudWatch + SNS

🤝 Contributing
git checkout -b feature/amazing-feature
git commit -m "feat: add amazing feature"
git push origin feature/amazing-feature

📄 License

MIT License

🙏 Acknowledgments

AWS

HashiCorp Terraform

Kubernetes

The Open Source Community
