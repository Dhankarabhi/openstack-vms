#cloud-config
runcmd:
  - [ bash, -c, "curl -fsSL http://169.254.169.254/latest/meta-data/instance-id || true" ]
  - [ bash, -c, "echo 'Running SSH setup script...'" ]
  - [ bash, -c, "chmod +x /tmp/setup-ssh.sh && /tmp/setup-ssh.sh" ]

write_files:
  - path: /tmp/setup-ssh.sh
    permissions: '0755'
    owner: root:root
    content: |
      #!/bin/bash
      set -e
      apt-get update -y
      apt-get install -y openssh-server sudo
      if id "admin" &>/dev/null; then
          echo "User 'admin' already exists."
      else
          useradd -m admin
      fi
      echo "admin:123" | chpasswd
      usermod -aG sudo admin
      sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
      sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
      if ! grep -q "^AllowUsers" /etc/ssh/sshd_config; then
          echo "AllowUsers admin" >> /etc/ssh/sshd_config
      else
          sed -i '/^AllowUsers/s/$/ admin/' /etc/ssh/sshd_config
      fi
      systemctl enable ssh
      systemctl restart ssh
