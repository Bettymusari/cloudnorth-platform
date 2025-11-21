# Create Key Pair
resource "tls_private_key" "cloudnorth_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cloudnorth_kp" {
  key_name   = "cloudnorth-keypair"
  public_key = tls_private_key.cloudnorth_key.public_key_openssh
}

# Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "cloudnorth-ec2-sg"
  description = "Security group for CloudNorth EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloudnorth-ec2-sg"
  }
}

# Frontend EC2 Instance
resource "aws_instance" "frontend" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.cloudnorth_kp.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>CloudNorth Frontend Server</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "cloudnorth-frontend"
  }
}

# Backend EC2 Instance
resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.cloudnorth_kp.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              echo "CloudNorth Backend Server" > /tmp/backend-setup.txt
              EOF

  tags = {
    Name = "cloudnorth-backend"
  }
}
