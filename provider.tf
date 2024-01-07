provider "aws" {
    region = "eu-west-1"
    profile = "autodiscovery"
}

provider "vault" {
    address = "https://${var.domain}"
    token = var.token
}

