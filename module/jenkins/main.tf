#create instance 
resource "aws_instance" "jenkins" {
  ami           = var.ami02
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  subnet_id              = var.subnet02
  key_name               = var.key
  associate_public_ip_address = true
  user_data              =templatefile("./module/jenkins/Jenkins-user-data.sh", {
    var1=var.nexus-ip})
  tags = {
    Name = "${var.projectname}-Jenkins"
  }
}

#create security groups for jenkins
resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "jenkins SG"
  vpc_id      = var.vpc

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "app_jenkins"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "http_port"
    from_port        = 80
    to_port          = 80
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


resource "aws_elb" "jenkins-lb" {
  name               = var.elb-name
  subnets            = var.subnet04
  security_groups    = [aws_security_group.jenkins.id]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = [aws_instance.jenkins.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.projectname}-elb"
  }
}

