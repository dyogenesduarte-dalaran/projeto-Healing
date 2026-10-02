# Como iniciar o Metabase localmente

Este documento descreve os passos básicos para iniciar o Metabase localmente com Docker e acessar o dashboard do Projeto Healing.

## Passos para iniciar

### 1. Iniciar o container

```bash
docker start metabase
```

### 2. Verificar se o container está em execução

```bash
docker ps
```

### 3. Acessar o Metabase no navegador

```text
http://localhost:3000
```

### 4. Consultar os logs, caso necessário

```bash
docker logs -f metabase
```

## Encerrar o Metabase

Quando quiser parar o container:

```bash
docker stop metabase
```

## Observação

Este procedimento considera que o container do Metabase já foi criado anteriormente com o nome:

```text
metabase
```

As credenciais de banco de dados e demais configurações sensíveis não devem ser armazenadas neste arquivo nem publicadas no GitHub.
