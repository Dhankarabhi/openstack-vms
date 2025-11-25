#!/bin/bash
# Exit immediately if a command fails
set -e

# Variables
USERNAME="newuser"
PASSWORD="StrongPassword123"   # Change this as needed

# Create new user if it doesn't exist
if ! id -u "$USERNAME" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd
    usermod -aG sudo "$USERNAME"
    echo "User '$USERNAME' created and added to sudoers."
else
    echo "User '$USERNAME' already exists. Skipping creation."
fi
