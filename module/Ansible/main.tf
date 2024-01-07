resource "aws_instance" "ansible" {
  ami           = var.ami
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.ansible-sg.id]
  subnet_id              = var.subnet
  key_name               = var.key
  associate_public_ip_address = true
  user_data              = local.ansible-user-data
  tags = {
    Name = "${var.projectname}-ansible" 
  }
}
#create security groups for ansible
resource "aws_security_group" "ansible-sg" {
  name        = "ansible-sg"
  description = "ansible"
  vpc_id      = var.vpc

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
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