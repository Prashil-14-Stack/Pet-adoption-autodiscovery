#!/bin/bash
sudo yum update -y
sudo yum install git maven wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
 https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install java-17-openjdk -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo yum install -y yum-utilis
sudo yum config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=NRAK-OHILGVY6L3PWBH7U89AOITMEX6T NEW_RELIC_ACCOUNT_ID=4250635 NEW_RELIC_REGION=EU /usr/local/bin/newrelic install -y

sudo yum install docker-ce -y
sudo service docker start
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
sudo chmod 777 /var/run/docker.sock
sudo cat <<EOT> /etc/docker/daemon.json
{
    "insecure-registries" :  ["${var1}:8085"]
}
EOT
sudo systemctl restart docker
sudo hostnamectl set-hostname jenkins 
