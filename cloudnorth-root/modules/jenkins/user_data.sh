#!/bin/bash
# Jenkins installation user data script

# Update system
yum update -y

# Install Docker
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user
systemctl enable docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Jenkins dependencies
yum install -y java-11-amazon-corretto-headless wget

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins

# Add Jenkins to docker group
usermod -a -G docker jenkins

# Configure Jenkins to listen on all interfaces
sed -i 's/JENKINS_LISTEN_ADDRESS=""/JENKINS_LISTEN_ADDRESS="0.0.0.0"/' /etc/sysconfig/jenkins

# Start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Create setup script for later
cat > /home/ec2-user/setup-jenkins.sh << 'EOF'
#!/bin/bash
echo "Jenkins initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "Jenkins URL: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"
EOF

chmod +x /home/ec2-user/setup-jenkins.sh

echo "Jenkins installation complete!"
echo "Run /home/ec2-user/setup-jenkins.sh to get initial password"
