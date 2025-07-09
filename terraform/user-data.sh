#!/bin/bash

sudo yum update -y

# Instalar Docker
sudo amazon-linux-extras install docker -y

# Inicia serviço do Docker
sudo systemctl enable docker
sudo systemctl start docker

# Adiciona ec2-user ao grupo do docker
sudo usermod -a -G docker ec2-user

# Instala docker compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

