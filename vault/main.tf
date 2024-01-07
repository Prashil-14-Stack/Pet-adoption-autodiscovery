provider "aws" {
    region = "eu-west-1"
    profile ="autodiscovery"
}
resource "tls_private_key" "key"{
    algorithm = "RSA"
    rsa_bits = 4096
} 

resource "local_file" "key"{
content  = tls_private_key.key.private_key_pem
filename = "vault.pem"
file_permission = "600"
}

resource "aws_key_pair" "key"{
 key_name = "vault-key"
 public_key = tls_private_key.key.public_key_openssh
}

#create security groups for Vault
resource "aws_security_group" "vault-sg" {
  name        = "vault-sg"
  description = "vault"
  

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
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
    description      = "vault port"
    from_port        = 8200
    to_port          = 8200
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "port"
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

#instance for vault
resource "aws_instance" "vault" {
  ami           = "ami-0694d931cee176e7d"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.vault-sg.id]
  key_name               = aws_key_pair.key.key_name
  associate_public_ip_address = true 
  iam_instance_profile = aws_iam_instance_profile.vault-kms-unseal.id
  user_data              =templatefile("./vault-user-data.sh" ,{
    var2=aws_kms_key.vault.id,
    var3=var.domain-name,
    var4=var.email,
    var5=var.region
  })
  tags = {
    Name = "${var.projectname}-vault"
  }
}

resource "aws_kms_key" "vault" {
  description             = "vault unseal key"
  deletion_window_in_days = 10
  tags = {
    Name = "vault-kms-unseal"
  }
}

data "aws_route53_zone" "route53_zone" {
  name         = var.domain-name
  private_zone = false
}

resource "aws_route53_record" "vault_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = var.domain-name
  type    = "A"
  ttl     = 300
  records = [aws_instance.vault.public_ip]
}

