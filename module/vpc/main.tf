

#Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Environment = "VPC-Pet"
  }
}

#Create a public subnet
resource "aws_subnet" "pub-sub-01" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.Pubsub01_cidr
  availability_zone = "eu-west-1a"
  tags = {
    Environment = "Pub-sub01"
  }
}

#Create a public subnet
resource "aws_subnet" "pub-sub-02" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.Pubsub02_cidr
  availability_zone = "eu-west-1b"
  tags = {
    Environment = "Pub-sub02"
  }
}

#Create a private subnet
resource "aws_subnet" "pri-sub-01" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.Prisub01_cidr
  availability_zone = "eu-west-1a"
  tags = {
    Environment = "Pri-sub01"
  }

}

#Create a private subnet
resource "aws_subnet" "pri-sub-02" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.Prisub02_cidr
  availability_zone = "eu-west-1b"
  tags = {
    Environment = "Pri-sub02"
  }
  
}


#Create a IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  
}

# Creating nat gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub-sub-01.id
  depends_on    = [aws_internet_gateway.gw]
  
}

#Create a elastic IP
resource "aws_eip" "eip" {
  domain   = "vpc"
  depends_on = [aws_internet_gateway.gw]
}

#Create a public route table
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
}

#Create a private route table
resource "aws_route_table" "pri-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }
  
}

#Create a public route table association
resource "aws_route_table_association" "pub-ass-01" {
  subnet_id      = aws_subnet.pub-sub-01.id
  route_table_id = aws_route_table.pub-rt.id
}

#Create a public route table association
resource "aws_route_table_association" "pub-ass-02" {
  subnet_id      = aws_subnet.pub-sub-02.id
  route_table_id = aws_route_table.pub-rt.id
}

#Create a private route table association
resource "aws_route_table_association" "pri-ass-01" {
  subnet_id      = aws_subnet.pri-sub-01.id
  route_table_id = aws_route_table.pri-rt.id
}

#Create a private route table association
resource "aws_route_table_association" "pri-ass-02" {
  subnet_id      = aws_subnet.pri-sub-02.id
  route_table_id = aws_route_table.pri-rt.id
}

resource "tls_private_key" "key"{
    algorithm = "RSA"
    rsa_bits = 4096
} 

resource "local_file" "ssh_key"{
content  = tls_private_key.key.private_key_pem
filename = "prv.pem"
file_permission = "600"
}

resource "aws_key_pair" "key"{
 key_name = var.keypair_name
 public_key = tls_private_key.key.public_key_openssh
}

