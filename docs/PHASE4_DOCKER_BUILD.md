## 🔷 Phase 4 — Application Containerization

This phase was the turning point—my app became fully containerized, stateless, cloud-native, and ready for EKS.

Phase 4 was all about taking my application code (frontend + backend), packaging everything neatly inside Docker containers, testing them locally on my Jenkins EC2 instance, and getting everything ready for automated CI/CD in Phase 5.

This phase was where the app finally started to feel “real.”

###🔹 4.1 Cloning My CloudNorth Platform Code on Jenkins EC2

Jenkins EC2 is my build machine, so I pulled my application code there:

git clone https://github.com/Bettymusari/cloudnorth-platform.git
cd cloudnorth-platform
git checkout feature/ci-cd-pipeline


This branch contains:

frontend/ → Next.js 16 App Router UI

backend/ → Node.js API

Dockerfiles for both

Jenkins pipeline

Configs for later EKS deployment

###🔹 4.2 Fixing Node.js & Next.js Requirement Issues

Next.js 16 requires Node 20+, so I installed it on the Jenkins EC2 instance:

curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo yum install -y nodejs


Verification:

node -v
npm -v


✔ Node 20
✔ npm 10

Ready for building.

###🔹 4.3 Adding the App Logo (Optional but Nice Touch)

I generated a custom logo and uploaded it to Jenkins EC2:

On my laptop:
scp -i cloudnorth-keypair.pem logo.png ec2-user@<JENKINS-PUBLIC-IP>:/home/ec2-user/

On Jenkins EC2:
mkdir -p ~/cloudnorth-platform/frontend/public
mv ~/logo.png ~/cloudnorth-platform/frontend/public/logo.png


Final structure:

frontend/
 ├── app/
 ├── public/
 │    └── logo.png
 ├── Dockerfile
 ├── package.json

###🔹 4.4 Building the Frontend Docker Image

Inside Jenkins EC2:

cd ~/cloudnorth-platform/frontend
docker build -t cloudnorth-frontend:latest .


If successful, the output ends with:

Successfully tagged cloudnorth-frontend:latest

###🔹 4.5 Testing the Frontend Container

Local test:

docker run -p 3000:3000 cloudnorth-frontend:latest


Expected console output:

▲ Next.js 20
✔ Ready on http://localhost:3000


Note:

This runs only inside the EC2 (private subnet).
It is NOT expected to open on your laptop browser.
It’s for build verification only.

###🔹 4.6 Building the Backend Docker Image
cd ~/cloudnorth-platform/backend
docker build -t cloudnorth-backend:latest .


Output:

Successfully tagged cloudnorth-backend:latest

###🔹 4.7 Testing the Backend API Container
docker run -p 8080:8080 cloudnorth-backend:latest


Then inside EC2:

curl http://localhost:8080/health


Expected JSON:

{ "status": "healthy" }

###🔹 4.8 Why We Test Locally

This part is important:

✔ Jenkins EC2 is NOT for hosting the app
✔ It is ONLY for building and verifying containers
✔ Final deployment happens on EKS (Phase 5)
✔ Jenkins pipeline will push images to Docker Hub
✔ EKS will pull those images and run them in Kubernetes

Local testing ensures:

Dockerfile works

App builds correctly

No missing dependencies

Ports expose correctly

CI/CD will not fail later

###🔹 4.9 Final Phase 4 Outcome

By the end of Phase 4:

✅ Frontend container builds without errors
✅ Backend container builds without errors
✅ Both containers run successfully on Jenkins EC2
✅ Logo added and working
✅ Node.js + Next.js environment stabilized
✅ Project is now ready for CI/CD automation
🟢 We are officially ready for Phase 5: Deploying to EKS with Helm & Blue-Green
🎉 Phase 4 Completed Successfully

This phase was honestly the turning point.
Everything that will run in Kubernetes later started here.
Now we move to the real magic: Kubernetes + Helm + ALB + Blue/Green.
