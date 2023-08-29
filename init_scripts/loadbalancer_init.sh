#!/bin/bash
# Atualiza o sistema
echo "Atualizando o sistema"
sudo apt update && sudo apt upgrade -y
sudo apt-get install ca-certificates curl gnupg -y
echo "Atualizado"
echo "----------"

# Adicionando usuário para github-actions
read -p "Por favor, insira o nome do usuário que deseja criar: " USERNAME

# 1. Criar o usuário
sudo apt install -y openssh-server
sudo useradd $USERNAME

# 2. Adicionar o usuário ao grupo wheel
sudo usermod -aG sudo $USERNAME

# 3. Criar um diretório .ssh no diretório inicial do usuário
sudo mkdir /home/$USERNAME/.ssh
sudo chmod 700 /home/$USERNAME/.ssh

# 4. Solicitar a chave pública SSH do usuário e salvar no arquivo ~/.ssh/authorized_keys desse usuário
echo "Por favor, cole sua chave pública SSH e pressione Ctrl+D quando terminar:"
sudo tee /home/$USERNAME/.ssh/authorized_keys > /dev/null
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

echo "Usuário $USERNAME criado e configurado para autenticação por chave SSH."
echo "Não esqueça de configurar o a chave secreta no repositório para que as automações funcionem!"
echo "----------"

# Instala o Git
echo "Instalando Git"
sudo apt install git -y
echo "Instalado"
echo "----------"

# Instala o curl
echo "Instalando curl"
sudo apt install curl -y
echo "Instalado"
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
sudo service docker start
sudo usermod -aG docker $USER
sudo usermod -aG docker $USERNAME
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
cd /
git clone --filter=blob:none --no-checkout https://github.com/devs2blu-status200/projeto-lightsail.git
sudo chown -R $USERNAME:$USER /projeto-lightsail
sudo chmod -R 774 /projeto-lightsail
git config --global --add safe.directory /projeto-lightsail
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