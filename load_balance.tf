// Security Group for ALB: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/vpc-security-groups.html
resource "aws_security_group" "example-sg-alb" {
  name        = "example-alb-sg"
  vpc_id      = aws_vpc.example-vpc.id
  description = "Example of SG for ALB"
  // Full outbound access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // Allow HTTP/HTTPS inbound traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "example-alb-sg"
    Environmnet = "dev"
  }
}

resource "aws_lb" "example-alb" {
  name            = "example-app-load-balancer"
  subnets         = [aws_subnet.PublicSubnetA.id, aws_subnet.PublicSubnetB.id, aws_subnet.PublicSubnetC.id]
  security_groups = [aws_security_group.example-sg-alb.id]
  internal        = false
  idle_timeout    = 60
  tags_all = {
    Name = "example-app-load-balancer"
    Environmnet = "dev"
  }
}

// ALB Target Group  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "example-tg" {
  name     = "example-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.example-vpc.id
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = 80
  }
  tags_all = {
    Name = "example-target_group"
    Environmnet = "dev"
  }
}


// ALB Listener https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "lb-listener-http" {
  load_balancer_arn = aws_lb.example-alb.arn
  port              = 80
  protocol          = "HTTP"
  // Default Action
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example-tg.arn
  }
  tags_all = {
    Name = "example-lb-listener-http"
    Environmnet = "dev"
  }
}

// This will require a certficate (ACM) to be created
# resource "aws_lb_listener" "lb-listener-https" {
#   load_balancer_arn = aws_lb.example-alb.arn
#   port              = 443
#   protocol          = "HTTPS"

#   certificate_arn = aws_acm_certificate.example-cert.arn

#   default_action {
#     type = "forward"
#   }
# }