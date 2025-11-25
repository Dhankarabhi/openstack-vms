#!/bin/bash
# Minimal OpenSSH install and enable script for Terraform user_data

# Install OpenSSH server if not already installed
if ! dpkg -s openssh-server >/dev/null 2>&1; then
    apt-get update
    apt-get install -y openssh-server
fi

# Ensure SSH service is enabled and running
systemctl enable ssh
systemctl start ssh