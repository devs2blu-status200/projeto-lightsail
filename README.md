# Documentação do Projeto no Lightsail na AWS:
## STATUS200.sol.app.br

### Introdução:

O motivo da documentação é para servir de orientação na conexão de imagens na Web e suas configurações como Load Balancer, certificado SSL, banco de dados. Assim vamos nos apegar em detalhes técnicos de como foi construída a estrutura na AWS. 

### O que é Amazon Lightsail?

Serviço de computação em nuvem oferecido pela AWS, que tem o objeito de simplificar a implementação e gerenciamento de aplicações em websites. Facilidade de uso, alguns recursos já pré-configurados são alguns dos pontos que ajudam na simplificação. 

#

### Passo a passo: Criando banco de dados.

Criar instância de banco de dados do lightsail na região us-east-2 (Ohio)

É necessário informar um nome para o master database.

Anotar usuário, senha, host do banco e nome do master database.


#

### Criando Containers WordPress:

No menu Containers vamos em criar novo container, sendo na mesma região da base de dados.

Selecionamos a versão nano e vamos para o Set Up deployment, especificando a customização do deploy

Nome do container: wordpress-status200-<x>

Imagem escolhida: bitnami/wordpress:latest

Adicionar variáveis de ambiente:

WORDPRESS_DATABASE_PASSWORD: senha do banco

WORDPRESS_DATABASE_USER: usuário do banco

WORDPRESS_DATABASE_HOST: É o endpoint da nossa base de dados. 

WORDPRESS_DATABASE_NAME: nome do master database

Liberar também as portas:

Porta 8080 no protocolo HTTP e porta 8443 no HTTPS


Esse processo de Deploy pode ser realizado 2 vezes usando os mesmos parâmetros, visto que a imagem WordPress vai ter Load Balancer. 

#

### Load Balancer:

Para Load Balancer vamos criar uma instância com uma imagem de Ubuntu.

Selecionar a plataforma Linux/Unix, OS Only e Ubuntu 22.04 LTS. 

Para identificar a instância usamos o nome "load-balancer-status200"

E podemos criar. 

Após a criação vamos acessar essa instância de Ubuntu usando SSH, no próprio painel da instância. 

Executar sudo apt-get update

Instalar o docker

Subir uma segunda instância baseada no Amazon Linux 2023. Dessa instância, copiar o arquivo /etc/resolv.conf para a instância de load balancer, no mesmo caminho. Com isso é possível fazer a resolução de domínios internos da AWS.

Configurar DNS para apontar endereços de interesse para essa máquina de load balancer.

Instalar e executar o certbot para obter os certificados e chaves SSL dos domínios.

no diretório home, executar os seguintes comandos para clonar apenas arquivos nginx do projeto github

```bash
git clone --filter=blob:none --no-checkout https://github.com/devs2blu-status200/projeto-lightsail.git
cd projeto-lightsail
git sparse-checkout init --cone
git sparse-checkout set nginx
git checkout
```

Não esqueça de confirmar se a configuração do docker-compose está correta em relação ao endereço dos arquivos de certificado e chave. Os volumes criados pelo `docker-compose.yml` devem ser correspondentes aos arquivos indicados no `nginx.conf`.

Para subir o nginx basta executar

```bash
cd nginx
docker compose up -d
```

### Containers com aplicações

Na instancia criada com uma imagem do amazon linux 2023 adicione um nome de status200-apps.

Instalar o docker

Clonar o repositorio `PROJETO-LIGHTSAIL` utilizando os comandos abaixo.

```bash
git clone --filter=blob:none --no-checkout https://github.com/devs2blu-status200/projeto-lightsail.git
cd projeto-lightsail
git sparse-checkout init --cone
git sparse-checkout set main-directory
git checkout
```
Para copiar apenas os arquivos do diretório principal.

Dentro da pasta princial chamada `PROJETO-LIGHTSAIL` encontra-se um arquivo chamado `docker-compose.yml` onde está armazenada a configuração de cada aplicação que será feito o deploy em containers separados e mapeado em portas diferentes.

No mesmo diretório encontra-se o `.env` contendo as variavéis de ambientes para a conexão das aplicações com o banco de dados.

### Configuração docker-compose.yml

```bash
version: '3.8'

services:
  node:
    image: lucastheiss31/nodecontainer:latest
    pull_policy: always
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: development
    env_file:
      - .env
    command: npm start

  java:
    image: lucastheiss31/webjavav2:latest
    pull_policy: always
    ports:
      - "3001:8080"

  dotnet:
    image: lucastheiss31/aspnetapp:latest
    pull_policy: always
    ports:
      - "3002:80"
```

### Licensa

Este projeto está sob licença do MIT.








