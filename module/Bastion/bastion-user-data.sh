#!/bin/bash
echo "pubkeyAcceptedkeyTypes=+ssh_rsa" >> /etc/ssh/sshd_config.d/10-insecure-rsa-keysig
sudo systemctl restart sshd
echo "${private_key_pem}" >> /home/ubuntu/.ssh/id_rsa
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
chgrp ubuntu /home/ubuntu/.ssh/id_rsa
chmod 600 /home/ubuntu/.ssh/id_rsa
sudo hostnamectl set-hostname bastion