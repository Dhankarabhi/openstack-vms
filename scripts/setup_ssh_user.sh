#!/bin/bash
set -e

apt-get update -y
apt-get install -y openssh-server sudo

# Create demo user
useradd -m demo || true
echo "demo:123" | chpasswd
usermod -aG sudo demo

# Allow demo & ubuntu users
echo "AllowUsers demo ubuntu" >> /etc/ssh/sshd_config

# Enable password authentication
sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
if [ -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf ]; then
  sed -i "s/^.*PasswordAuthentication no.*/PasswordAuthentication yes/" /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
fi

systemctl enable ssh
systemctl restart ssh
