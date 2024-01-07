output "private_key_pem" {
    value = tls_private_key.key.private_key_pem
}
output "pubsubnet01" {
    value = aws_subnet.pub-sub-01.id
}
output "vpc" {
    value = aws_vpc.vpc.id 
}
output "key" {
    value = aws_key_pair.key.key_name
}
output "prisubnet01" {
    value=aws_subnet.pri-sub-01.id
}
output "pubsubnet02" {
    value = aws_subnet.pub-sub-02.id
}

output "prisubnet02" {
    value=aws_subnet.pri-sub-02.id
}

output "local_file" {
   value = local_file.ssh_key.id
}

output "private-keypair" {
  value = tls_private_key.key.private_key_pem
}