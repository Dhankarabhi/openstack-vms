#!/bin/bash
 
useradd -m demo
echo "demo:123" | chpasswd
usermod -aG sudo demo
sudo chsh -s /bin/bash demo
echo "AllowUsers demo ubuntu" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
sed -i "s/^.*PasswordAuthentication no.*/# &/" /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
systemctl restart ssh
