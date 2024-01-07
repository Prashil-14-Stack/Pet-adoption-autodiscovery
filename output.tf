output "bastion" {
    value = module.Bastion.bastion_host
  
}

output "Jenkins" {
    value = module.Jenkins.Jenkins_host
 
}
output "nexus" {
    value = module.nexus.nexus_host
 
}
output "jenkins-lb" {
    value = module.Jenkins.jenkins-lb
  
}

output "sonarqube" {
    value =module.sonarqube.sonarqube_host
  
}

output "stage_dns" {
    value = module.environment-lb.stage_dns
}


output "prod_dns" {
    value =module.environment-lb.prod_dns
}

output "ansible" {
    value = module.ansible.ansible_host
}

output "rds_endpoint" {
    value = module.rds.endpoint
}
