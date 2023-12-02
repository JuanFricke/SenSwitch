# Sensor Monitoring App

Este projeto é parte do curso de Gestão de Infraestruturas da Universidade Regional do Noroeste do Estado do Rio Grande do Sul (UNIJUÍ). O objetivo deste aplicativo é verificar o status dos sensores armazenados no banco de dados RethinkDB, fornecendo um painel de controle e notificações para os usuários.

## Tecnologias Utilizadas

- Ruby v3.2.2
- Rails v7.0.8
- RethinkDB gem para integração com o banco de dados
- Dotenv Rails para configuração de variáveis de ambiente
- Whenever para agendar tarefas Rake
- Bulma CSS para estilos
- SQLite para armazenamento de dados (desenvolvimento/teste)

## Recomendação de instalação do rails

Recomendo seguir o guia de instalação do Ruby e Rails fornecido pelo site GoRails para configurar seu ambiente de desenvolvimento. O guia abrange as etapas necessárias para instalar o Ruby, o Rails e outras dependências.


1. Acesse o guia de instalação do GoRails em [https://gorails.com/setup](https://gorails.com/setup).

2. Siga as instruções fornecidas para configurar o ambiente de desenvolvimento Ruby on Rails. O guia inclui etapas para instalação no Ubuntu e outras distribuições Linux.

## Usando GitHub Codespaces

Rails é preferencialmente instalado no linux, podendo ser usado o wsl no windows 10/11. Pessoalmente recomendo o uso do codespaces do github, pela praticidade de um ambiente 100% configurado, sem necessidade de instalar vms, dockers, wsl, ou rodar diretamente na maquina(pois nem todos contam com ubuntu instalado).

Caso queira rodar localmente, a recomendação é usar um sistema baseado em ubuntu, justamente por conta do rethinkdb, caso seja necessario criar dados de forma local. O rethink infelizmente tem de ser compilado na maioria dos sistemas fora do ecosistema .deb


## Configuração

1. Clone o repositório:

```bash
   git clone https://github.com/JuanFricke/SenSwitch.git
```
1. Instale as dependências:

```bash
    cd SenSwitch
    bundle install
```
2. Configure as variáveis de ambiente:

* Crie um arquivo .env na raiz do projeto e adicione as configurações necessárias, como as credenciais do RethinkDB.
```ini
RETHINKDB_HOST=external_ip
#internal ip address:
#RETHINKDB_HOST=internal_ip
RETHINKDB_PORT=db_port
RETHINKDB_DB=db_name
RETHINKDB_USER=db_user_name
RETHINKDB_PASSWORD=db_user_password
```

3. Execute as migrações do banco de dados:

```bash

rails db:migrate
```
4. Inicie o servidor Rails:

```bash
    bundle exec clockwork config/clock.rb
    rails server
```
5. Acesse o aplicativo em http://localhost:3000.
Uso



Este projeto está licenciado sob a Licença MIT.