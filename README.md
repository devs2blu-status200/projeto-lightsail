# Documentação do Projeto no Lightsail na AWS:
## STATUS200.sol.app.br

### Introdução:

O motivo da documentação é para servir de orientação na conexão de imagens na Web e suas configurações como Load Balancer, certificado SSL, banco de dados. Assim vamos nos apegar em detalhes técnicos de como foi construída a estrutura na AWS. 

### O que é Amazon Lightsail?

Serviço de computação em nuvem oferecido pela AWS, que tem o objeito de simplificar a implementação e gerenciamento de aplicações em websites. Facilidade de uso, alguns recursos já pré-configurados são alguns dos pontos que ajudam na simplificação. 

### Passo a passo: Criando banco de dados.

Criar instância de banco de dados do lightsail na região `us-east-2 (Ohio)`

É necessário informar um nome para o master database.

Anotar usuário, senha, host do banco e nome do master database.


### Criando Containers WordPress:

No menu Containers vamos em criar novo container, sendo na mesma região da base de dados.

Selecionamos a versão nano e vamos para o Set Up deployment, especificando a customização do deploy

Nome do container: `wordpress-status200-<x>`

Imagem escolhida: `bitnami/wordpress:latest`

Adicionar variáveis de ambiente:

`WORDPRESS_DATABASE_PASSWORD`: senha do banco

`WORDPRESS_DATABASE_USER`: usuário do banco

`WORDPRESS_DATABASE_HOST`: É o endpoint da nossa base de dados. 

`WORDPRESS_DATABASE_NAME`: nome do master database

Liberar também as portas:

Porta 8080 no protocolo HTTP e porta 8443 no HTTPS


Esse processo de Deploy pode ser realizado 2 vezes usando os mesmos parâmetros, visto que a imagem WordPress vai ter Load Balancer. 


### Load Balancer:

Criar uma instância com uma imagem de Ubuntu. Selecionar a plataforma Linux/Unix, OS Only e Ubuntu 22.04 LTS. Identificar a instância com o nome `load-balancer-status200`.

Acessar essa instância de Ubuntu usando SSH, no próprio painel da instância. 

Execute os seguintes comandos para obter e iniciar o script de configuração do servidor.

```bash
curl -O https://raw.githubusercontent.com/devs2blu-status200/projeto-lightsail/main/init_scripts/loadbalancer_init.sh
chmod +x apps_init.sh
./apps_init.sh
```
O script vai solicitar o nome do usuário de automação e a chave pública de acesso, forneça ambos e não esqueça de configurar os segredos `LB_ACTIONS_USER` e `LB_ACTIONS_SECRET` do repositório com o nome do usuário definido e o valor da chave **privada**.

Subir uma segunda instância baseada no Amazon Linux 2023, identifique ela como `status-200-apps`. Dessa instância, copiar o arquivo `/etc/resolv.conf` para a instância de load balancer, no mesmo caminho. Com isso é possível fazer a resolução de domínios internos da AWS.

Criar um IP fixo para cada máquina.

Configurar DNS para apontar endereços de interesse para essa máquina de load balancer.

Instalar e executar o certbot para obter os certificados e chaves SSL dos domínios.

Não esqueça de confirmar se a configuração do docker-compose está correta em relação ao endereço dos arquivos de certificado e chave. Os volumes criados pelo `docker-compose.yml` devem ser correspondentes aos arquivos indicados no `nginx.conf`. Confirme também se os endereços IP indicados na configuração do Nginx estão corretos de acordo com o endereço IP criado para o servidor de apps.

Para subir o nginx basta executar

```bash
cd /projeto-lightsail/nginx
docker compose up -d
```

### Servidor de aplicações:

Gere um par de chaves para acesso ssh na sua máquina local, elas serão usadas para acesso remoto ao usuário de automação do servidor de aplicações.

Acesse o servidor Amazon Linux 2023 criado na etapa anterior e execute os seguintes comandos para obter e iniciar o script de configuração do servidor.

```bash
curl -O https://raw.githubusercontent.com/devs2blu-status200/projeto-lightsail/main/init_scripts/apps_init.sh
chmod +x apps_init.sh
./apps_init.sh
```

O script vai solicitar o nome do usuário de automação e a chave pública de acesso, forneça ambos e não esqueça de configurar os segredos `ACTIONS_USER` e `ACTIONS_KEY` do repositório com o nome do usuário definido e o valor da chave **privada**.

Uma vez concluído, para subir as aplicações basta executar.

```bash
docker-compose up -d
```

Você também deve configurar o firewall do servidor para aceitar conexões TCP somente do IP fixo atribuído ao servidor de load balance e somente nas portas definidas no `docker-compose.yml`.
Não se esqueça também de preencher as variáveis de ambiente no arquivo `.env` clonado do repositório. Esse arquivo **não deve** ser commitado depois de alterado.