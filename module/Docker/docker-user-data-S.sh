#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo chmod 777 /var/run/docker.sock
sudo cat <<EOT> /etc/docker/daemon.json
{
    "insecure-registries" :  ["${var1}:8085"]
}
EOT
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=NRAK-OHILGVY6L3PWBH7U89AOITMEX6T NEW_RELIC_ACCOUNT_ID=4250635 NEW_RELIC_REGION=EU /usr/local/bin/newrelic install -y
sudo hostnamectl set-hostname stage-instance