# vcaixa.delphi
## API de Controle de Caixa

Este projeto é composto por uma API que permite ao usuário cadastrar movimentações de caixa e obter um resumo diário destas movimentações. Ela foi desenvolvida em Delphi (versão Community Edition 10.3.3 Rio), utilizando o framework Delphi MVC Framework (Open Source) e o sistema de banco de dados PostgreSQL.

## Como rodar:
A API está hospedada na AWS e está disponível através do link: http://ec2-3-84-79-209.compute-1.amazonaws.com:8080/api

Para rodar em ambiente de desenvolvimento é necessário instalar o Delphi MVC Framework que está disponível através do link: https://github.com/danieleteti/delphimvcframework. Instale o PostgreSQL versão 9.4 (utilizei a versão de 32 bits). Defina o usuário "postgres" e senha "postgres" e crie o banco de dados de nome "api-caixa". Após isso, faça o restore do arquivo Banco.backup que se encontra na pasta "Banco". O sistema tentará se conectar no servidor localhost e porta 5432 (padrão do PostgreSQL). Para executar, o sistema depende das DLLs intl.dll, libeay32.dll, libpq.dll e ssleay32.dll que se encontram na pasta Win32/Debug.

## Como usar:

### Login
Para acessar os endpoints da API é necessário fazer o login. Para fins de testes, foi disponibilizado um usuário pré-cadastrado. Para efetuar o login, basta enviar uma requisição do tipo POST para o endpoint /login com e-mail e senha, conforme abaixo:
```json
{
    "email": "teste@teste.com",
    "senha": "12345678"
}
```

Ao fazer o login, serão devolvidos na resposta os dados do usuário e um token que deverá ser utilizado para acessar os demais endpoints. A autenticação utilizada é do tipo "Bearer token" e o token tem a duração de 1 hora:
```json
{
    "id": 1,
    "nome": "Usuário de teste",
    "email": "teste@teste.com",
    "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJBUEkgZGUgQ29udHJvbGUgZGUgQ2FpeGEiLCJleHAiOjE1OTk3OTY2NzMsIm5iZiI6MTU5OTc5Mjc3MywiaWF0IjoxNTk5NzkyNzczLCJpZCI6IjEiLCJ1c2VybmFtZSI6InRlc3RlQHRlc3RlLmNvbSIsImVtcHJlc2FfaWQiOiIxIn0.bzVlurortJ2j4ehYjurzUWR4gmrGatAtb-Wu4KSYqA4Asj2LR-LliqeCy4BclkmaKYqMdWkR20IFS1_WGS5RmA"
}
```

### Cadastro de categorias
Para cadastrar categorias, basta enviar uma requisição do tipo POST para o endpoint /categorias, conforme abaixo. Estão disponíveis algumas categorias pré-cadastradas que podem ser obtidas através do método GET:
```json
{
    "nome": "Alimentação"
}
```

### Cadastro de movimentações
Para cadastrar movimentações, basta enviar uma requisição do tipo POST para o endpoint /movimentacoes, conforme abaixo:
```json
{
    "categoria_id": 6,
    "data": "2020-09-10",
    "tipo": "SAIDA",
    "valor": 20.00,
    "descricao": "Fatura de telefone"
}
```

O campo "tipo" deve conter obrigatoriamente a string "ENTRADA" ou "SAIDA" dependendo do tipo da movimentação. O campo "categoria_id" deve conter o ID da categoria.

### Resumo diário
Para obter o resumo diário das movimentações, basta enviar uma requisição do tipo GET para o endpoint /resumo-diario. Serão retornados os dados de movimentação da data atual para a empresa a qual o usuário atual está vinculado. O usuário de teste mostrado no login acima, está vinculado a empresa de id = 1.
```json
{
    "saldoTotal": 90,
    "movimentacoes": [
        {
            "id": 1,
            "categoria": {
                "id": 1,
                "nome": "Vendas à vista"
            },
            "data": "2020-09-10",
            "tipo": "ENTRADA",
            "valor": 150,
            "descricao": "Venda de produtos"
        },
        {
            "id": 2,
            "categoria": {
                "id": 4,
                "nome": "Energia elétrica"
            },
            "data": "2020-09-10",
            "tipo": "SAIDA",
            "valor": 20,
            "descricao": "Fatura de fornecimento de água"
        },
        {
            "id": 3,
            "categoria": {
                "id": 5,
                "nome": "Material de limpeza"
            },
            "data": "2020-09-10",
            "tipo": "SAIDA",
            "valor": 40,
            "descricao": "Fatura de energia elétrica"
        }
    ]
}
```

### Outras features
Pode ser cadastrada uma nova empresa através do endpoint /registro utilizando o método POST. Neste cadastro, deve ser informado o nome da empresa, o CNPJ e os dados para a criação de um novo usuário como: e-mail, nome e senha:
```json
{
    "empresa": {
        "nome": "Nova empresa",
        "cnpj": "01001001000101"
    },
    "usuario": {
        "nome": "Novo usuário",
        "email": "novo@teste.com",
        "senha": "12345678"
    }
}
```
Após o registro da nova empresa, o usuário estará apto ao login no sistema.


