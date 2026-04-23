# cloud-init.yml.tpl
# Шаблон для инициализации ВМ через cloud-init
# Переменные: ${ssh_public_key}, ${project_label}

#cloud-config
users:
  - name: ubuntu
    # ssh-authorized-keys
    ssh-authorized-keys:
      - ${ssh_public_key}  # Переменная из vars = {}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash

packages:
  - nginx
  - curl
  - git

runcmd:
  # Включаем и запускаем nginx
  - systemctl enable nginx
  - systemctl start nginx
  
  # Создаём простую страницу с информацией о проекте
  - |
    cat > /var/www/html/index.html << 'EOF'
    <!DOCTYPE html>
    <html>
    <head><title>${project_label}</title></head>
    <body>
      <h1>Project: ${project_label}</h1>
      <p>Managed by Terraform</p>
    </body>
    </html>
    EOF

write_files:
  - path: /etc/motd
    content: |
      Welcome to ${project_label} VM!
    permissions: '0644'
