# #######################
# # ALB Module
# #######################

# Getters
data "aws_subnet" "get_subnet_id_1" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet-1"]
  }

  depends_on = [aws_subnet.public]
}

data "aws_subnet" "get_subnet_id_2" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet-2"]
  }

  depends_on = [aws_subnet.public]
}

data "aws_security_group" "get_sg_id" {
  filter {
    name   = "tag:Name"
    values = ["demo-security-group"]
  }

  depends_on = [aws_security_group.sg]
}

data "aws_vpc" "get_vpc_id" {
  filter {
    name   = "tag:Name"
    values = [var.name]
  }

  depends_on = [aws_vpc.this]
}

# Configure EC2 instances
resource "aws_instance" "instance_1" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.get_subnet_id_1.id # public-subnet-1
  vpc_security_group_ids = [data.aws_security_group.get_sg_id.id]

  tags = {
    Name = "Instance 1"
  }

  user_data = <<-EOF
             #!/bin/bash
             sudo apt-get update
             sudo apt-get install -y nginx
             sudo systemctl start nginx
             sudo systemctl enable nginx
             echo '<!doctype html>
             <html lang="en"><h1>Instance 1</h1></br>
             </html>' | sudo tee /var/www/html/index.html
             EOF
}

resource "aws_instance" "instance_2" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.get_subnet_id_2.id # public-subnet-2
  vpc_security_group_ids = [data.aws_security_group.get_sg_id.id]

  tags = {
    Name = "Instance 2"
  }

  user_data = <<-EOF
             #!/bin/bash
             sudo apt-get update
             sudo apt-get install -y nginx
             sudo systemctl start nginx
             sudo systemctl enable nginx
             echo '<!doctype html>
             <html lang="en"><h1>Instance 2</h1></br>
             </html>' | sudo tee /var/www/html/index.html
             EOF
}

# Configure ALB
resource "aws_lb" "load_balancer" {
  name            = "aws-lb"
  subnets         = [data.aws_subnet.get_subnet_id_1.id, data.aws_subnet.get_subnet_id_2.id]
  security_groups = [data.aws_security_group.get_sg_id.id]
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  # Return a 404 page by default
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.get_vpc_id.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "instance_1" {
  count            = var.num_instances
  target_group_arn = aws_lb_target_group.lb_target_group.arn
  target_id        = aws_instance.instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance_2" {
  count            = var.num_instances
  target_group_arn = aws_lb_target_group.lb_target_group.arn
  target_id        = aws_instance.instance_2.id
  port             = 80
}

resource "aws_lb_listener_rule" "lb_listener_rule" {
  listener_arn = aws_lb_listener.lb_listener.arn

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}
