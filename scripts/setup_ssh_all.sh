#!/bin/bash
set -e

apt-get update -y
apt-get install -y openssh-server sudo

# Ensure 'admin' user exists
if id "admin" &>/dev/null; then
    echo "User 'admin' already exists."
else
    useradd -m admin
    echo "User 'admin' created."
fi

# Set password for admin user
echo "admin:123" | chpasswd
usermod -aG sudo admin

# Enable password login
sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

# Allow SSH access for admin
if ! grep -q "^AllowUsers" /etc/ssh/sshd_config; then
    echo "AllowUsers admin" >> /etc/ssh/sshd_config
else
    sed -i '/^AllowUsers/s/$/ admin/' /etc/ssh/sshd_config
fi

systemctl enable ssh
systemctl restart ssh
