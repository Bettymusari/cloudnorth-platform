# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "cloudnorth-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Only allow HTTPS if certificate is provided
  dynamic "ingress" {
    for_each = var.certificate_arn != "" ? [1] : []
    content {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloudnorth-alb-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "cloudnorth" {
  name               = "cloudnorth-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "cloudnorth-alb"
  }
}

# Target Group for EKS
resource "aws_lb_target_group" "eks" {
  name        = "cloudnorth-eks-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "cloudnorth-eks-tg"
  }
}

# HTTP Listener (always created)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.cloudnorth.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "CloudNorth ALB - HTTP to HTTPS redirect coming soon"
      status_code  = "200"
    }
  }

  tags = {
    Name = "cloudnorth-http-listener"
  }
}

# HTTPS Listener (only created if certificate ARN is provided)
resource "aws_lb_listener" "https" {
  count = var.certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.cloudnorth.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "CloudNorth ALB - HTTPS backend services"
      status_code  = "200"
    }
  }

  tags = {
    Name = "cloudnorth-https-listener"
  }
}
