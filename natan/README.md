# Documentação do Projeto no Lightsail na AWS:
## STATUS200.sol.app.br

### Introdução:

O motivo da documentação é para servir de orientação na conexão de imagens na Web e suas configurações como Load Balaner, certificado SSL, banco de dados. Assim vamos nos apegar em detalhes técnicos de como foi construída a estrutura na AWS. 

### O que é Amazon Lightsail?

Serviço de computação em nuvem oferecido pela AWS, que tem o objeito de simplificar a implementação e gerenciamento de aplicações em websites. Facilidade de uso, alguns recursos já pré-configurados são alguns dos pontos que ajudam na simplificação. 

#

### Passo a passo: Criando banco de dados.

Para criação da base de dados utilizamos o recurso pré-configurado do Lightsail, no menu pode ser visto como "Databases". 
Vamos em Create Database e definimos os parâmetros solicitados.

Primeiro a localidade, definimos como "Ohio, Zone A (us-east-2a)"

Após escolhemos a database: MySQL 8.0.34 (no momento da criação). 

User Name: dbmasteruser
Password: -diJD6L+A75!>{.kG(50lfo{W-zXZESK
Nome do DB: Database-lucastheiss

Plano Stardard de 15 doláres/mês. 


#

### Criando Containers WordPress:

No menu Containers vamos em criar novo container, sendo na mesma região da base de dados.

Selecionamos a versão nano e vamos para o Set Up deployment, especificando a customização do deploy

Nome do container: wordpress-diogo-1

Imagem escolhida: bitnami/wordpress:latest

Adicionar variáveis de ambiente:

WORDPRESS_DATABASE_PASSWORD: -diJD6L+A75!>{.kG(50lfo{W-zXZESK

WORDPRESS_DATABASE_USER: dbmasteruser

WORDPRESS_DATABASE_HOST: ls-3692fdf38110da5d66a1151c2da89c229ef91767.c5g9jbippsk1.us-east-2.rds.amazonaws.com --> É o endpoint da nossa base de dados. 

WORDPRESS_DATABASE_NAME: dbstatus200

Adicionar também as portas para serem abertas:

Porta 8080 no protocolo HTTP e porta 8443 no HTTPS


Esse processo de Deploy pode ser realizado 2 vezes usando os mesmos parâmetros, visto que a imagem WordPress vai ter Load Balancer. 

#

### Load Balancer:

Para Load Balancer vamos criar uma instância com uma imagem de Ubuntu.

Selecionar a plataforma Linux/Unix, OS Only e Ubuntu 22.04 LTS. 

Para identificar a instância usamos o noem "load-balancer-status200"

E podemos criar. 

Após a criação vamos acessar essa instância de Ubuntu usando SSH, no próprio painel da instância. 

Antes de iniciar sudo apt-get update

criar um diretório para armazenar as chaves com sudo install -m 0755 -d /etc/apt/keyrings

Instalar o docker, primeiro atualizar os pacotes sudo apt-get update

E instalar: sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

Editar as configurações do docker e nginx editando os arquivos nginx.conf, docker-compose.yml, resolv.conf.

No nginx.confg foi definido o bloco upstream que direciona as solicitações para as duas instâncias wordpress.
O nginx vai redirecionar as solicitações HTTP para HTTPS no bloco server que escuta na porta 80. Outro bloco server escuta na porta 443, essa HTTPS. 

Bloco location configurado para encaminhar as solicitações das imagens wordprees pelo load balancer. 

### Configuração de Dominio e Certificados

Dominios status200.sol.app.br e www.status200.sol.app.br usando SSL, os caminhos para os certificados e cahves SSL foram configurados no arquivo nginx.conf.









