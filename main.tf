locals {
    name= "Pet-adoption-autodiscovery"
}


module "vpc" {
    source            = "./module/vpc"
    vpc_name          = "${var.projectname}-vpc"
    Pubsub01          = "${var.projectname}-pub-sub-01"
    Pubsub02          = "${var.projectname}-pub-sub-02"
    Prisub01          = "${var.projectname}-pri-sub-01"
    Prisub02          = "${var.projectname}-pri-sub-02"
    IGW               = "${var.projectname}-gw"
    natgw             = "${var.projectname}-natgw"
    Pubrt             = "${var.projectname}-pub-rt"
    Prvrt             = "${var.projectname}-pri-rt"
    eip               = "${var.projectname}-eip"
    Pubsub01_cidr     = "10.0.1.0/24"
    Pubsub02_cidr     = "10.0.2.0/24"
    Prisub01_cidr     = "10.0.3.0/24"
    Prisub02_cidr     = "10.0.4.0/24"
    bastion-ansible-SG = "${var.projectname}-bastion-ansible"
    Jenkins-SG        = "${var.projectname}-jenkins"
    sonarqube-SG      = "${var.projectname}-sonarqube"
    docker-SG         = "${var.projectname}-docker"
    nexus-SG          = "${var.projectname}-nexus"
    RDS-SG            = "${var.projectname}-RDS"
    keypair_name      = "${var.projectname}-keypair"
} 

module "Bastion" {
    source = "./module/Bastion"
    private_keyname = module.vpc.private_key_pem
    projectname = "${local.name}"
    subnet = module.vpc.pubsubnet01
    key = module.vpc.key
    ami = "ami-0694d931cee176e7d"
    vpc = module.vpc.vpc
}

module "Jenkins" {
    source = "./module/jenkins"
    projectname = var.projectname
    subnet04 = [module.vpc.pubsubnet01, module.vpc.pubsubnet02]
    subnet02 = module.vpc.prisubnet01
    key = module.vpc.key
    ami02 = "ami-049b0abf844cab8d7"
    vpc = module.vpc.vpc  
    elb-name = "jenkins-lb"
    nexus-ip= module.nexus.nexus_host
}

module "docker" {
    source = "./module/Docker"
    projectname = var.projectname
    key = module.vpc.key
    ami02 = "ami-049b0abf844cab8d7"
    vpc = module.vpc.vpc   
    nexus-ip = module.nexus.nexus_host
    zone-identifier = [module.vpc.prisubnet01, module.vpc.prisubnet02]
    stagename = "docker-stage"
    prodname = "docker-prod"
    stage_arn = [module.environment-lb.stage_tg_arn]
    prod_arn = [module.environment-lb.prod_tg_arn]
}


module "rds" {
    source = "./module/RDS"
    subnet_ids = [module.vpc.prisubnet01, module.vpc.prisubnet02] 
    projectname = var.projectname
    vpc = module.vpc.vpc
    username = data.vault_generic_secret.my_secret_db.data["username"]
    password = data.vault_generic_secret.my_secret_db.data["password"]
    dbname = "mydb"
    engine = "mysql"
}

data "vault_generic_secret" "my_secret_db" {
  path = "secret/database"
}

module "nexus" {
    source = "./module/Nexus"
    subnet03 =  module.vpc.pubsubnet02
    ami = "ami-049b0abf844cab8d7"
    vpc = module.vpc.vpc
    projectname = var.projectname
    key = module.vpc.key
}

module "ansible" {
    source="./module/Ansible"
    nexus-ip = module.nexus.nexus_host
    staging-MyPlaybook = "${path.root}/module/ansible/stage-env-playbook.yml"
    staging-discovery-script ="${path.root}/module/ansible/stage-env-bash-script.sh"
    prod-MyPlaybook = "${path.root}/module/ansible/prod-env-playbook.yml"
    prod-discovery-script = "${path.root}/module/ansible/prod-env-bash-script.sh"
    subnet = module.vpc.pubsubnet01
    projectname = var.projectname
    key =module.vpc.key
    ami = "ami-049b0abf844cab8d7"
    vpc = module.vpc.vpc
    private_key = module.vpc.private-keypair

}

module "sonarqube" {
    source = "./module/Sonarqube"
    projectname =var.projectname
    subnet =module.vpc.pubsubnet01
    key =module.vpc.key
    ami =var.ami
    vpc=module.vpc.vpc
}

module "environment-lb" {
   source="./module/environment-lb"
   projectname =var.projectname
   subnet04 = [module.vpc.pubsubnet02, module.vpc.pubsubnet01]
   vpc = module.vpc.vpc
   cert_arn = module.route53.aws_certificate
}

module "route53" {
    source = "./module/Route53"
    domain1= "theprashil.co.in"
    domain2 = "st.theprashil.co.in"
    stage_dns_name = module.environment-lb.stage_dns
    stage_zone_id = module.environment-lb.stage_zone_id
    domain3 = "p.theprashil.co.in"
    prod_dns_name2 = module.environment-lb.prod_dns
    prod_zone_id2 = module.environment-lb.prod_zone_id
    domain_name = "theprashil.co.in"
    domain_name4 = "*.theprashil.co.in"
}