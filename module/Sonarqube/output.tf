output "sonarqube_host" {
    value = aws_instance.sonarqube.public_ip
}