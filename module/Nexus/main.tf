#create instance 
resource "aws_instance" "nexus" {
  ami           = var.ami
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.nexus-Sg.id]
  subnet_id              = var.subnet03
  key_name = var.key
  associate_public_ip_address = true
  user_data              = local.nexus-user-data
  tags = {
    Name = "${var.projectname}-nexus" 
  }
}

#create security groups for NEXUS
resource "aws_security_group" "nexus-Sg" {
  name        = "nexus"
  description = "nexus SG"
  vpc_id      = var.vpc

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP Proxy2"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP Proxy3"
    from_port        = 8085
    to_port          = 8085
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



