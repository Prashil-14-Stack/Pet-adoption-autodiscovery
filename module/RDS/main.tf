resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  db_name              = var.dbname
  engine               = var.engine
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  multi_az = true
  skip_final_snapshot  = true
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds-sub-grp.id
}

resource "aws_db_subnet_group" "rds-sub-grp" {
  name       = "rds-grp_1"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

#create security groups for RDS
resource "aws_security_group" "rds-sg" {
  name        = "rds"
  description = "rds"
  vpc_id      = var.vpc

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "RDS"
    from_port        = 3306
    to_port          = 3306
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