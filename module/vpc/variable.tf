
variable "ssh" {
    default     = "22"
    description = "ssh"
}

variable "http" {
    default     = "80"
    description = "http"
}

variable "https" {
    default     = "443"
    description = "https"
}

variable "app_port" {
    default     = "8080"
    description = "app_port"
}
variable "http_proxy2" {
    default     = "8081"
    description = "http_proxy2"
}

variable "http_proxy3" {
    default     = "8085"
    description = "http_proxy3"
}


variable "vpc_cidr" {
    default     = "10.0.0.0/16"
    description = "vpc_cidr"
}

variable "vpc_name" {
  description = ""
}
variable "Pubsub01_cidr" {
    default =      "10.0.1.0/24"
}
variable "Pubsub02_cidr" {
  default     = "10.0.2.0/24"
}
variable "Prisub01_cidr" {
  default     = "10.0.3.0/24"
}
variable "Prisub02_cidr" {
  default     = "10.0.4.0/24"
}

variable "Pubsub01" {
    description = ""
}
variable "Pubsub02" {
   description = ""
}
variable "Prisub01" {
   description = ""
}
variable "Prisub02" {
   description = ""
}
variable "IGW" {
  description = ""
}
variable "natgw" {
  description = ""
}
variable "eip" {
  description = ""
}

variable "bastion-ansible-SG" {
  description = ""
}
variable "Jenkins-SG" {
  description = ""
}  
variable "sonarqube-SG" {
  description = ""
}
variable "docker-SG" {
  description = ""
}
variable "nexus-SG" {
  description = ""
}
variable "RDS-SG" {
  description = ""
}
 variable "keypair_name" {
  description = ""
}
variable "Prvrt"{
  description = ""
}

variable "Pubrt"{
  description = ""
}
