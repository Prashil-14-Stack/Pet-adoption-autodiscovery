output "Jenkins_host" {
    value = aws_instance.jenkins.private_ip
}
output "jenkins-lb" {
  value=aws_elb.jenkins-lb.dns_name
}
