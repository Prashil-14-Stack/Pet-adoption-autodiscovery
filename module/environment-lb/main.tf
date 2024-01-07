resource "aws_lb_target_group" "stage-target-group" {
  name     = "target-group-name"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_listener" "LB-listener-stage01" {
  load_balancer_arn = aws_lb.stage_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stage-target-group.arn
  }
}

resource "aws_lb_listener" "LB-listener-stage02" {
  load_balancer_arn = aws_lb.stage_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stage-target-group.arn
  }
}

resource "aws_lb" "stage_lb" {
  name               = "stage-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.env-Sg.id]
  subnets            = var.subnet04
  enable_deletion_protection = false
  tags = {
    Environment = "stage"
  }
}


resource "aws_lb_target_group" "prod-target-group" {
  name     = "prod-target-group-name"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_listener" "LB-listener-prod01" {
  load_balancer_arn = aws_lb.prod_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   =var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod-target-group.arn
  }
}

resource "aws_lb_listener" "LB-listener-prod02" {
  load_balancer_arn = aws_lb.prod_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod-target-group.arn
  }
}

resource "aws_lb" "prod_lb" {
  name               = "prod-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.env-Sg.id]
  subnets            = var.subnet04
  enable_deletion_protection = false
  tags = {
    Environment = "production"
  }
}
#create security groups for env
resource "aws_security_group" "env-Sg" {
  name        = "env-Sg"
  description = "env Sg"
  vpc_id      = var.vpc
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    description      = "port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}