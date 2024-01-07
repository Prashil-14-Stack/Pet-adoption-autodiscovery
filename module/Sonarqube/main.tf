#create instance 
resource "aws_instance" "sonarqube" {
  ami           = var.ami
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.sonarqube-Sg.id]
  subnet_id              = var.subnet
  key_name               = var.key
  associate_public_ip_address = true
  user_data              = local.sonarqube-user-data
  tags = {
    Name = "${var.projectname}-sonarqube" 
  }
}


#create security groups for sonarqube
resource "aws_security_group" "sonarqube-Sg" {
  name        = "sonarqube"
  description = "sonarqube SG"
  vpc_id      = var.vpc

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Proxy"
    from_port        = 9000
    to_port          = 9000
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
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}



