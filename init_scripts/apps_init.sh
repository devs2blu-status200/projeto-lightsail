#!/bin/bash
# Atualiza o sistema
echo "Atualizando o sistema"
sudo dnf check-update && sudo dnf upgrade -y
echo "Atualizado"
echo "----------"

# Adicionando usuário para github-actions
read -p "Por favor, insira o nome do usuário que deseja criar: " USERNAME

# 1. Criar o usuário
sudo dnf install -y openssh-server
sudo useradd $USERNAME

# 2. Adicionar o usuário ao grupo wheel
sudo usermod -aG wheel $USERNAME

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
echo "Instalando o Git"
sudo dnf install git -y
echo "Instalado"
echo "----------"

# Instala o curl
echo "Instalando o curl"
sudo dnf install curl -y
echo "Instalado"
echo "----------"

# Instala o Docker
echo "Instalando Docker"
sudo dnf install docker -y
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo service docker start
sudo usermod -aG docker $USER
sudo usermod -aG docker $USERNAME
echo "Instalado Docker"
echo "----------"

# Clona o projeto git
echo "Clonando o projeto git"
cd /
sudo git clone --filter=blob:none --no-checkout https://github.com/devs2blu-status200/projeto-lightsail.git
sudo chown -R $USERNAME:$USER /projeto-lightsail
sudo chmod -R 774 /projeto-lightsail
git config --global --add safe.directory /projeto-lightsail
cd projeto-lightsail
git sparse-checkout init --cone
git sparse-checkout set docker-compose.yml
git checkout
echo "Clonado"
echo "----------"

echo "Configuração inicial concluída, não esqueça de: "
echo "-Preencher as credenciais de acesso a banco no arquivo .env"
echo "-Executar o docker-compose up -d para subir as aplicações"

# Criar uma partição de swap
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Adicionar a partição de swap ao /etc/fstab para ativação na inicialização
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Verificar a partição de swap
sudo swapon --show
sudo free -h

echo "Partição de swap configurada com sucesso."