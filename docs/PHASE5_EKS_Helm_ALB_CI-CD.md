✨ 1️⃣ GitHub README – Phase 5 (EKS + Helm + ALB + CI/CD)

Title: Phase 5 – Deploying a Production-Ready Microservices Application on Amazon EKS Using Helm & ALB

📌 Overview

Phase 5 focuses on deploying the CloudNorth microservices application (frontend + backend) onto a production-ready Kubernetes environment using Amazon EKS, Helm, ECR, and the AWS Load Balancer Controller for ALB Ingress.

This phase completes the core cloud-native deployment pipeline of the entire CloudNorth Project.

🔧 What Was Implemented
1. EKS Access Configuration

The Jenkins EC2 instance was configured to authenticate against the EKS cluster using:

aws eks update-kubeconfig

IAM roles for service accounts (IRSA)

Node group role with ECR and EC2 read permissions

2. Helm Chart Architecture

A custom Helm chart was created:

myapp-chart/
├── Chart.yaml
├── values.yaml
└── templates/
      ├── backend-deployment.yaml
      ├── backend-service.yaml
      ├── frontend-deployment.yaml
      ├── frontend-service.yaml
      ├── ingress-alb.yaml
      ├── secret.yaml
      ├── configmap.yaml
      └── _helpers.tpl


This chart templatized:

Deployments

Services

ConfigMaps

Secrets

ALB Ingress

Image tags & environment variables

3. Containerization & Pushing to ECR

Both services were built, tagged and pushed:

docker build -t myapp-backend ./backend
docker build -t myapp-frontend ./frontend

docker tag myapp-backend:latest <AWS_ID>.dkr.ecr.<region>.amazonaws.com/myapp-backend:latest
docker tag myapp-frontend:latest <AWS_ID>.dkr.ecr.<region>.amazonaws.com/myapp-frontend:latest

docker push <ECR>/myapp-backend:latest
docker push <ECR>/myapp-frontend:latest

4. AWS Load Balancer Controller (ALB Ingress)

To support Ingress, the following were implemented:

OIDC provider for EKS

IAM role for ALB controller

Controller installed via Helm

Subnet tagging for auto-discovery

Ingress rules for routing traffic

Result: The app receives an external HTTPS-ready ALB endpoint.

5. Deployment Using Helm

Application deployed and upgraded with:

helm upgrade --install myapp ./myapp-chart -n myapp --create-namespace
kubectl get ingress -n myapp


The ALB came up with its DNS:

k8s-myapp-myapping-xxxxxxx.us-east-1.elb.amazonaws.com

✅ Final Outcome

✔ Fully deployed microservices on EKS
✔ Frontend & Backend running as separate deployments
✔ Internal service-to-service networking
✔ External access via AWS Application Load Balancer
✔ Environment variables and secrets configured
✔ CI/CD-ready setup for Jenkins to automate deployments

📎 Phase 5 Completed

CloudNorth now has a production-grade Kubernetes infrastructure with ALB ingress and Helm deployments.
