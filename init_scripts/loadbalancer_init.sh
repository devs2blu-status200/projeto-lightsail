#!/bin/bash
# Atualiza o sistema
echo "Atualizando o sistema"
sudo apt update && sudo apt upgrade -y
sudo apt-get install ca-certificates curl gnupg -y
echo "Atualizado"
echo "----------"

# Instala o Docker
echo "Instalando Docker"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Instalado Docker"
echo "----------"

# Instala o Certbot
echo "Instalando Certbot"
sudo apt install snapd -y
sudo apt-get remove certbot -y
sudo snap install --classic certbot -y
sudo ln -s /snap/bin/certbot /usr/bin/certbot
echo "Instalado Certbot"
echo "----------"

# Clona o projeto git
echo "Clonando o projeto git"
git clone --filter=blob:none --no-checkout https://github.com/devs2blu-status200/projeto-lightsail.git
cd projeto-lightsail
git sparse-checkout init --cone
git sparse-checkout set nginx
git checkout
echo "Clonado"
echo "----------"

echo "Configuração inicial concluída, não esqueça de: "
echo "-Obter os certificados usando o Certbot"
echo "-Corrigir o /etc/resolv.conf conforme explicado no README"
echo "-Ajustar os caminhos no docker-compose.yml do Nginx"
echo "-Executar o docker-compose up -d para subir o servidor"