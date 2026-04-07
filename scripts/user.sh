#!/bin/bash

useradd -m admin-user
echo "admin-user:TechRajendra123" | chpasswd
usermod -aG sudo admin-user
sudo chsh -s /bin/bash admin-user
echo "AllowUsers admin-user ubuntu" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
sed -i "s/^.*PasswordAuthentication no.*/# &/" /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
systemctl restart ssh
