#create launch template 
resource "aws_launch_template" "stage_lt" {
  name_prefix          = "docker_launch_temp"
  image_id             = var.ami02
  instance_type        = "t2.medium"
  vpc_security_group_ids = [aws_security_group.docker-Sg.id]
  key_name               = var.key
  user_data              =base64encode(templatefile("./module/Docker/docker-user-data-S.sh",{
    var1= var.nexus-ip
  }))
  tags = {
    Name = "${var.projectname}-stage-lt"
  }
}

resource "aws_autoscaling_group" "docker-auto-scaling-stage" {
  name                      = var.stagename
  max_size                  = 5
  min_size                  = 1
  target_group_arns = var.stage_arn
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = var.zone-identifier
  launch_template{
    id = aws_launch_template.stage_lt.id
  }
  tag {
    key = "Name"
    value = "${var.projectname}-stage"
    propagate_at_launch = true
  }
}

#create launch template 
resource "aws_launch_template" "prod_lt" {
  name_prefix          = "docker_launch_temp"
  image_id             = var.ami02
  instance_type        = "t2.medium"
  vpc_security_group_ids = [aws_security_group.docker-Sg.id]
  key_name               = var.key
  user_data              =base64encode(templatefile("./module/Docker/docker-user-data-P.sh",{
    var1= var.nexus-ip
  }))
  tags = {
    Name = "${var.projectname}-prod-lt"
  }
}

resource "aws_autoscaling_group" "docker-auto-scaling-prod" {
  name                      = var.prodname
  target_group_arns = var.prod_arn
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = var.zone-identifier
  launch_template{
    id = aws_launch_template.stage_lt.id
  }
  tag {
    key = "Name"
    value = "${var.projectname}-docker-prod"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_policy" "docker-asg-policy-stage" {
  name                   = "docker-asg-policy-stage"
  #scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.docker-auto-scaling-stage.id
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
resource "aws_autoscaling_policy" "docker-asg-policy-prod" {
  name                   = "docker-asg-policy-prod"
  #scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.docker-auto-scaling-prod.id
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
#create security groups for docker
resource "aws_security_group" "docker-Sg" {
  name        = "docker"
  description = "docker SG"
  vpc_id      = var.vpc

  ingress {
    description      = "SSH"
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
    description      = "app_docker"
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

