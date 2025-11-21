#🚀 Phase 3: Continuous Integration (CI/CD Pipeline Automation with Jenkins

(Betty’s Experience Log)

## “The Pipeline That Succeeded on Attempt 22”

Phase 3 was where CloudNorth really became alive.
Up until now, I had infrastructure code, Dockerfiles, and application code sitting quietly in their folders.
But Phase 3 is where I wired everything together and created a real production-style CI/CD pipeline — automated, repeatable, and brutally honest when something breaks.
This is the stage where I took my raw repository and transformed it into an automated, reproducible, fully containerized CI/CD pipeline — powered by Jenkins, Docker, and GitHub.

And to be honest? … something definitely broke.
In fact, multiple things broke.
This phase did not go smoothly, and it took 22 attempts to get a fully successful pipeline.

But that’s exactly why this phase matters to me — because CI/CD is not a theory exam.
It’s debugging, rebuilding, adjusting, and trying again until the pipeline finally behaves.

### 1. Preparing the Jenkins Environment (The Foundations)

Before touching any pipeline code, I had to prepare and expose Jenkins properly.

🔸 1.1 Exposing Jenkins on Port 8081

I configured Jenkins to run on:

http://0.0.0.0:8081

This meant editing the Jenkins service file:

sudo vi /usr/lib/systemd/system/jenkins.service

And updating:

--httpPort=8081
--httpListenAddress=0.0.0.0

Then:

sudo systemctl daemon-reload
sudo systemctl restart jenkins

🔸 1.2 Updating EC2 Security Groups

To support CloudNorth’s architecture, I opened these ports:

Port

Purpose

8081

Jenkins UI

3000

Frontend container

9090

Prometheus

9093

Alertmanager

This ensured nothing in my pipeline would break because of blocked traffic.

### 2. Connecting Jenkins to GitHub

CI/CD cannot exist without source control.
So the next step was securely integrating GitHub.

🔸 2.1 Creating Secure GitHub Credentials

In Jenkins:

Manage Jenkins → Credentials → Global

I added:

ID: my-github-credentials

Type: Personal Access Token

Scope: Global

🔸 2.2 Validating Git Checkout

My Jenkinsfile uses the built-in checkout scm:

stage('Checkout') {
    steps {
        checkout scm
    }
}

Pipeline logs confirmed successful Git fetches.

### 3. Preparing Jenkins for Kubernetes Deployment

Even though EKS deployment comes later, the groundwork starts here.

🔸 3.1 Installing Kubernetes Tools

sudo curl -LO "https://dl.k8s.io/release/$(uname -r)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/

🔸 3.2 Adding kubeconfig to Jenkins User

sudo su - jenkins
mkdir -p ~/.kube
cp /home/ec2-user/.kube/config ~/.kube/config

This allows future pipeline stages to deploy images straight to EKS.

### 4. Writing the Jenkinsfile (My Pipeline Brain)

Here’s the CI pipeline I built:

pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Backend Setup') {
            steps {
                dir('backend') {
                    sh 'npm ci'
                    sh 'npm run lint'
                }
            }
        }

        stage('Frontend Setup') {
            steps {
                dir('frontend') {
                    sh 'npm ci'
                    sh 'npm run lint'
                }
            }
        }

        stage('Build Frontend') {
            agent {
                docker {
                    image 'node:20-alpine'
                    reuseNode true
                }
            }
            steps {
                dir('frontend') {
                    sh 'npm run build'
                }
            }
        }

        stage('Docker Test') {
            steps {
                sh 'docker compose build --no-cache'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed'
        }
        success {
            echo '✅ SUCCESS: All stages completed!'
        }
    }
}

This pipeline:

Installs backend dependencies

Installs frontend dependencies

Builds frontend inside a Node 20 container

Runs a full docker compose build

### 5. Dockerfile Fixes (The Troubleshooting Battle)

This part was the core cause of most failures.

❌ Old Dockerfile: incompatible with Next.js 16

Next.js 16 requires Node ≥20.9.0.

My original Dockerfile was:

FROM node:18-alpine

Jenkins threw:

You are using Node.js 18.20.8. For Next.js, Node.js version ">=20.9.0" is required.

To fix it, I rebuilt the Dockerfile.

✅ Final Working Dockerfile (after 22 attempts)

### --- Builder Stage --- ###
FROM node:20-alpine AS builder

WORKDIR /app

### Copy package files and install dependencies
COPY package*.json ./
RUN npm ci --only=production

### Copy source code
COPY . .

### Build the application
RUN npm run build


### --- Runner Stage (Production) --- ###
FROM node:20-alpine AS runner

WORKDIR /app

### Create non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

### Copy build artifacts
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

USER nextjs

EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["npm", "start"]

This fixed:

Node engine mismatch

Missing /public folder

Multi-stage build errors

Next.js build failures

Docker builds — what actually ran (and where docker build happened)

Short answer: I didn’t run docker build manually, but the pipeline absolutely ran docker build under the hood — via Docker Compose + Buildx, and via Jenkins’ container runner when building the frontend.

How the pipeline triggered builds

When Jenkins reached the Docker test stage it executed:

docker compose build --no-cache

That single command caused Docker Compose (using Buildx) to run docker build for each service defined in docker-compose.yml:

docker build for backend (context: ./backend)

docker build for frontend (context: ./frontend)

So the docker build activity was fully automated by Compose.

Frontend build inside a container (also Docker)

For the frontend compile step Jenkins used a Node 20 container:

agent {
  docker {
    image 'node:20-alpine'
    reuseNode true
  }
}

Under the hood Jenkins did:

docker pull node:20-alpine
docker run --rm -v /workspace:/work -w /work node:20-alpine npm run build

This is why the logs show full build output like next build — it ran inside the container.

Buildx involvement

Modern docker compose build uses Buildx for multi-stage builds and advanced features. That’s why upgrading Buildx to v0.17+ was required. Buildx drove the layer creation, caching and the strict COPY checks that forced the /app/public fix.

Typical log lines you’ll see (evidence of docker build)

These lines in the pipeline log are direct output from the docker build process:

Image tagging & pushing (future/CD note)

Right now docker compose build built local images (named like cloudnorthpipeline-backend). For a full CD workflow you’ll add a push step:

### tag the image
docker tag cloudnorthpipeline-backend:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/cloudnorth-backend:1.0.0

### login (example)
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account>.dkr.ecr.<region>.amazonaws.com

### push
docker push <account>.dkr.ecr.<region>.amazonaws.com/cloudnorth-backend:1.0.0

### 6. The 22 Attempts (My Personal DevOps Journey)

These were the kinds of errors I battled:

🔸 Missing Docker Compose Plugin

docker: 'compose' is not a docker command.

Fixed by installing:

sudo mkdir -p /usr/lib/docker/cli-plugins
sudo mv docker-compose /usr/lib/docker/cli-plugins/
sudo chmod +x /usr/lib/docker/cli-plugins/docker-compose

🔸 Buildx Too Old

compose build requires buildx 0.17 or later

Fixed by upgrading:

sudo curl -SL https://github.com/docker/buildx/releases/download/v0.17.1/buildx-v0.17.1.linux-amd64 -o /usr/lib/docker/cli-plugins/docker-buildx
sudo chmod +x /usr/lib/docker/cli-plugins/docker-buildx

🔸 Missing /public folder

COPY --from=builder /app/public ./public  
"/public": not found

I solved this by ensuring the build output actually produced the public directory.

Each error taught me something new.
Each fix made the pipeline more stable.

### 7. Attempt #22 — The Green Build That Made It All Worth It

After multiple Dockerfile rewrites, Git pushes, Jenkins restarts, Buildx upgrades, and pipeline reruns…

I finally got this:

Pipeline completed
✅ SUCCESS: All stages completed!

That was Attempt 22.
And honestly, it felt like passing a DevOps certification exam — but harder.

My CI Pipeline Diagram

                         ┌──────────────────────────┐
                         │        GitHub Repo       │
                         │  cloudnorth-platform     │
                         └─────────────┬────────────┘
                                       │
                              (Webhook / Manual)
                                       │
                           ┌──────────▼──────────┐
                           │      Jenkins CI     │
                           │   (EC2 Instance)    │
                           └──────────┬──────────┘
                                      │
                    ┌─────────────────┴──────────────────┐
                    │                                    │
         ┌──────────▼──────────┐              ┌──────────▼──────────┐
         │   Stage 1: Checkout │              │ Stage 2: Backend     │
         │  Git clone + branch │              │ npm ci + lint        │
         └──────────┬──────────┘              └──────────┬──────────┘
                    │                                    │
         ┌──────────▼──────────┐              ┌──────────▼──────────┐
         │ Stage 3: Frontend   │              │ Stage 4: Build FE   │
         │ npm ci + lint       │              │ Node 20 container   │
         └──────────┬──────────┘              │ next build          │
                    │                         └──────────┬──────────┘
                    │                                    │
                    └────────────────────┬───────────────┘
                                         │
                              ┌──────────▼──────────┐
                              │ Stage 5: Docker Test│
                              │ docker compose build │
                              └──────────┬──────────┘
                                         │
                                 ┌───────▼────────┐
                                 │  Pipeline OK 💚 │
                                 │  Ready for CD   │
                                 └─────────────────┘

### 8. 🌟What This Phase Demonstrates About My Skills

CI/CD pipeline design from scratch

Debugging real Jenkins failures

Docker multi-stage builds

Node engine compatibility troubleshooting

Buildx / Docker Compose plugin management

GitHub → Jenkins secure integration

Kubeconfig preparation for EKS deployments

Security group configuration

Real-world SRE-style problem solving

Persistence, patience, resilience

This is not a classroom pipeline.
This is a production-style CI/CD pipeline that fought back — and I won. Although I did not invoke docker build manually, Jenkins triggered full image builds via docker compose build (backed by Buildx). The frontend build also ran inside a Node 20 Docker container (docker run ... npm run build), ensuring all artifacts were produced inside isolated, reproducible environments.


### XPhase 4 Preview: Advanced Deployment & Monitoring

🌐 AWS ECS/EKS deployment for container orchestration

🔐 Environment-specific configurations (dev/staging/prod)

📊 CloudWatch monitoring and alerting

🔒 Security hardening and compliance
