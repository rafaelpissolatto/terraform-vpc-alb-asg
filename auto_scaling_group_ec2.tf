
// generate key: https://ubuntu.com/tutorials/ssh-keygen-on-windows#1-overview
// ssh-keygen -t rsa -b 4096 -C
resource "aws_key_pair" "auth" {
  key_name   = "ec2_key_pair"
  public_key = file("./key_pair/ec2_key_pair.pub")
}

resource "aws_launch_template" "example-lc" {
  name                   = "example-launch-template"
  image_id               = data.aws_ami.amazon-linux-2.id
  instance_type          = "t3a.medium"
  vpc_security_group_ids = [aws_security_group.example-ec2-sg.id]
  user_data              = file("user_data.tpl.sh")
  key_name               = aws_key_pair.auth.key_name
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = "20"
      volume_type           = "gp3"
      delete_on_termination = "true"
    }
  }
}

resource "aws_autoscaling_group" "example-autoscale-group" {
  vpc_zone_identifier = [aws_subnet.PrivateSubnetA.id, aws_subnet.PrivateSubnetB.id, aws_subnet.PrivateSubnetC.id]
  target_group_arns   = [aws_lb_target_group.example-tg.arn]
  min_size            = 1
  max_size            = 3

  launch_template {
    id      = aws_launch_template.example-lc.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "example-auto-scaling-group"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }
}

// Security Group for EC2: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
resource "aws_security_group" "example-ec2-sg" {
  name        = "example-ec2-sg"
  vpc_id      = aws_vpc.example-vpc.id
  description = "Example of SG for EC2/ASG"
  // Full outbound access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // Allow HTTP inbound traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "example-ec2-sg"
    Environmnet = "dev"
  }
}
