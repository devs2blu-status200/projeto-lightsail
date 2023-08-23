#!/bin/bash
# Atualiza o sistema
echo "Atualizando o sistema"
sudo dnf check-update && sudo dnf upgrade -y
echo "Atualizado"
echo "----------"

# Instala o Docker
echo "Instalando Docker"
sudo dnf install docker -y
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "Instalado Docker"
echo "----------"

# Clona o projeto git
echo "Clonando o projeto git"
git clone --filter=blob:none --no-checkout https://github.com/devs2blu-status200/projeto-lightsail.git
cd projeto-lightsail
git sparse-checkout init --cone
git sparse-checkout set docker-compose.yml
git checkout
echo "Clonado"
echo "----------"

echo "Configuração inicial concluída, não esqueça de: "
echo "-Executar o docker-compose up -d para subir os aplicações"