output "ansible_host" {
    value = aws_instance.ansible.public_ip
}