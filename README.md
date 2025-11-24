# 🥘 MESA PLUS

---

## Índice

- [Visão Geral](#visão-geral)  
- [URL base](#url-base)  
- [Respostas comuns](#respostas-comuns)  
- [Empresas](#empresas)  
- [ONGS](#ongs)  
- [Usuários](#usuarios)
- [Alimentos](#alimentos)
- [Pedidos](#pedidos)
- [Favoritos](#favoritos)
- [Filtros](#filtros)      

---

## 🔗 Visão Geral

Esta API tem como objetivo realizar o **gerenciamento de alimentos para doação**, conectando empresas, ONGs e pessoas que necessitam de alimentos.  
O sistema permite que alimentos próximos ao prazo de validade sejam cadastrados e disponibilizados para instituições e usuários interessados, reduzindo o desperdício e ajudando no combate à fome no Brasil.

---

## 👥 Tipos de Usuários

A plataforma possui **três módulos de usuários**, cada um com funcionalidades específicas:

### 🍽️ **Empresas Alimentícias**
- Podem cadastrar alimentos próximos do prazo de validade
- Podem atualizar ou remover itens cadastrados
- Funcionam como única fonte de doaçãos do sistema

### 🏛️ **ONGs**
- Podem realizar o cadastro da instituição
- Podem visualizar alimentos disponíveis
- Podem adicionar alimentos desejados ao carrinho para retirada no local

### 👤 **Usuários Comuns**
- Podem realizar um cadastro pessoal
- Podem visualizar os alimentos disponíveis
- Podem adicionar alimentos desejados ao carrinho para retirada no local

---

## 🎯 Objetivo do Projeto

O projeto busca:

- **Reduzir o desperdício de alimentos** em empresas alimentícias  
- **Facilitar o processo de doação** para ONGs e pessoas necessitadas  
- **Conectar quem pode doar e quem precisa receber**, de forma simples e organizada  
- **Contribuir no combate à fome no Brasil**, garantindo que alimentos que seriam descartados sejam reaproveitados

---

## URL base
https://mesaplus-bbh2hhheaab7f6ep.canadacentral-01.azurewebsites.net/v1/mesa-plus

---

## Respostas comuns

| Status | Status code | Mesnsagem |
|--------|-------------|-----------|
|  True  |     201     |Item criado com sucesso!!|
| False  |     400     |Não foi possível realizar a requisição, pois existem campos obrigatórios que não foram preenchidos ou não atendem a quantidade de caracteres!!!|
| False  |     415     |Não foi possível processar a requisição, pois o tipo de dados encaminhado não é processado pelo servidor. Favor encaminhar dados apenas no formato JSON!!!|
| False  |     500     |Devido a erros internos no servidor da model, não foi possível processar a requisição!!!|

---

## 🍽️ Empresas
### ✏️ Método: `POST`
###  🔀  Caminho: /empresa
### 📌 Descrição: Inserir nova empresa

---

### 📥 Exemplo de Body

```json
{
  "nome": "Mesa Plus",
  "email": "mesa.plus@gmail.com",
  "senha": "1234",
  "cnpj_mei": "1111111111111",
  "telefone": "(11) 9111-1111",
  "endereco": "Rua das flores n°1"
}
```
### 📤 Exemplo de Retorno (201)
```json
{
  "status": true,
  "status_code": 201,
  "message": "Item criado com sucesso!!",
  "empresa": {
    "id": 7,
    "nome": "Mesa Plus",
    "email": "mesa.plus@gmail.com",
    "senha": "$2b$10$WR/pI.P1amiy.qLVxehSDOzRXOwtl8kuauxXNVsgTOyNxCYoxvXrm",
    "cnpj_mei": "1111111111111",
    "telefone": "(11) 9111-1111",
    "endereco": "Rua da flores n° 1"
  }
}
```
### ⚠️ Possível Erro (400)
```json
{
  "status": false,
  "status_code": 400,
  "message": "Não é possível cadastrar um email ou cpf/cnpj que já foi cadastrado!!!"
}
```

### ✏️ Método: `GET`
###  🔀  Caminho: /empresa
### 📌 Descrição: Listar todas as empresas

---

### 📤 Exemplo de Retorno (200)
```json
{
  "status": true,
  "status_code": 200,
  "itens": 5,
  "empresas": [
    {
      "id": 1,
      "nome": "Nome atualizado",
      "email": "BurgerKing@gmail.com",
      "senha": "$2b$10$6ZGwhfS.kUFPtL07r61RtOPSLL1lKI.D4WODToq929WcCrEEM8VLy",
      "cnpj_mei": "12121212121212",
      "telefone": "11111111111",
      "foto": null,
      "data_modificacao": "2025-11-18T20:01:45.000Z",
      "codigo_recuperacao": null,
      "codigo_expiracao": null,
      "endereco": null
    }
  ]
}
```
### ✏️ Método: `GET`
###  🔀  Caminho: /empresa/${id da empresa}
### 📌 Descrição: Bucar uma empresa pelo id 

---

### 📤 Exemplo de Retorno (200)
```json
{
  "status": true,
  "status_code": 200,
  "empresa": {
    "id": 1,
    "nome": "Nome atualizado",
    "email": "BurgerKing@gmail.com",
    "senha": "$2b$10$6ZGwhfS.kUFPtL07r61RtOPSLL1lKI.D4WODToq929WcCrEEM8VLy",
    "cnpj_mei": "12121212121212",
    "telefone": "11111111111",
    "foto": null,
    "data_modificacao": "2025-11-18T20:01:45.000Z",
    "codigo_recuperacao": null,
    "codigo_expiracao": null,
    "endereco": null
  }
}
```
### ✏️ Método: `PUT`
###  🔀  Caminho: /empresa/${id da empresa}
### 📌 Descrição: Atualizar uma empresa pelo id 

---

### 📥 Exemplo de Body

```json
{
  "nome": "BK"
}
```

### 📤 Exemplo de Retorno (200)
```json
{
  "status": true,
  "status_code": 200,
  "message": "Item atualizado com sucesso!!",
  "empresa": {
    "nome": "BK"
  }
}
```
### ⚠️ Possível Erro (400)
(Empresa não existe)
```json
{
  "status": false,
  "status_code": 400,
  "message": "Não foram encontrados itens de retorno!!!"
}
```

---

## 🏛️ ONGs
### ✏️ Método: `POST`
### 🔀  Caminho: /ong
### 📌 Descrição: Inserir nova ong

---

### 📥 Exemplo de Body

```json
{
    "nome": "Sementes do amanhã",
    "email": "sementes.doamanha@gmail.com",
    "senha": "1234",
    "telefone": "(11) 91111-1111"
}
```
### 📤 Exemplo de Retorno (201)
```json
{
  "status": true,
  "status_code": 201,
  "message": "Item criado com sucesso!!",
  "ong": {
    "id": 7,
    "nome": "Sementes do amanhã",
    "email": "sementes.doamanha@gmail.com",
    "senha": "$2b$10$XPRoMMDVTFtNrcICnAwa.usl6IkM1mNVZeozutl/28rA.5posAFym",
    "telefone": "(11) 91111-1111"
  }
}
```
### ⚠️ Possível Erro (400)
```json
{
  "status": false,
  "status_code": 400,
  "message": "Não é possível cadastrar um email ou cpf/cnpj que já foi cadastrado!!!"
}
```
### ✏️ Método: `GET`
###  🔀  Caminho: /ong/${id da ong}
### 📌 Descrição: Bucar uma ong pelo id 

---

### 📤 Exemplo de Retorno (200)
```json
{
  "status": true,
  "status_code": 200,
  "ong": {
    "id": 1,
    "nome": "Ajuda ao que precisam",
    "email": "Aqp@gmail.com",
    "senha": "$2b$10$ScoI1I8epl/VE.s17CWRSeOiHv0My9Mqg.Z4oy6ikrimpyU5AKWEi",
    "telefone": "7657563455",
    "foto": null,
    "data_modificacao": null,
    "codigo_recuperacao": null,
    "codigo_expiracao": null
  }
}
```
### ✏️ Método: `PUT`
###  🔀  Caminho: /ong/${id da ong}
### 📌 Descrição: Atualizar uma ong pelo id 

---

### 📥 Exemplo de Body

```json

{
  "nome": "Ajuda aos necessitados"  
}
```

### 📤 Exemplo de Retorno (200)
```json
{
  "status": true,
  "status_code": 200,
  "message": "Item atualizado com sucesso!!",
  "usuario": {
    "nome": "Ajuda aos necessitados"
  }
}
```
### ⚠️ Possível Erro (400)
(Ong não existe)
```json
{
  "status": false,
  "status_code": 400,
  "message": "Não foram encontrados itens de retorno!!!"
}
```

---

## 👤 Usuários Comuns
### ✏️ Método: `POST`
### 🔀  Caminho: /usuario
### 📌 Descrição: Inserir novo usuário

---

### 📥 Exemplo de Body

```json
{
    "nome": "Fernada Nascimento",
    "email": "fernanda.nascimento@gmail.com",
    "senha": "12345",
    "cpf": "111.11111.2",
    "telefone": "(11) 91111-1111"
}
```
### 📤 Exemplo de Retorno (201)
```json
{
  "status": true,
  "status_code": 201,
  "message": "Item criado com sucesso!!",
  "usuario": {
    "id": 8,
    "nome": "Fernada Nascimento",
    "email": "fernanda.nascimento@gmail.com",
    "senha": "$2b$10$NEmnxXEq70BodNFeoRCXgOYwc8BQl598H0ji94aCq21MrJv0NPsWq",
    "cpf": "111.11111.2",
    "telefone": "(11) 91111-1111"
  }
}
```
### ⚠️ Possível Erro (400)
```json
{
  "status": false,
  "status_code": 400,
  "message": "Não é possível cadastrar um email ou cpf/cnpj que já foi cadastrado!!!"
}
```
### ✏️ Método: `GET`
###  🔀  Caminho: /usuario/${id da usuario}
### 📌 Descrição: Bucar um usuário pelo id 

---

### 📤 Exemplo de Retorno (200)
```json
{
  "status": true,
  "status_code": 200,
  "usuario": {
    "id": 8,
    "nome": "Fernada Nascimento",
    "email": "fernanda.nascimento@gmail.com",
    "senha": "$2b$10$NEmnxXEq70BodNFeoRCXgOYwc8BQl598H0ji94aCq21MrJv0NPsWq",
    "cpf": "111.11111.2",
    "telefone": "(11) 91111-1111",
    "foto": null,
    "data_modificacao": null,
    "codigo_recuperacao": null,
    "codigo_expiracao": null
  }
}
```
### ✏️ Método: `PUT`
###  🔀  Caminho: /usuario/${id da usuario}
### 📌 Descrição: Atualizar um usuário pelo id 

---

### 📥 Exemplo de Body

```json
{
  "nome": "Fernanda"  
}
```

### 📤 Exemplo de Retorno (200)
```json
{
  "status": true,
  "status_code": 200,
  "message": "Item atualizado com sucesso!!",
  "usuario": {
    "nome": "Fernanda"
  }
}
```
### ⚠️ Possível Erro (400)
(Usuário não existe)
```json
{
  "status": false,
  "status_code": 400,
  "message": "Não foram encontrados itens de retorno!!!"
}
```
---

## 🍝 Alimentos

### ✏️ Método: `POST`
### 📌 Descrição: Inserir novo alimento

---

### 📥 Exemplo de Body

```json
{
    "nome":"teste 6",
    "quantidade": 2,
    "peso": 2,
    "data_de_validade": "20-12-2025",
    "descricao": "http://foto.jpg",
    "imagem":"http://link.mp4",
    "id_empresa":1,
    "id_tipo_peso": 1,
    "categorias": [
        {"id": 1},
        {"id": 2}
    ]
}
```
### 📤 Exemplo de Retorno (201)
```json
{
  "status": true,
  "status_code": 201,
  "message": "Item criado com sucesso!!",
  "alimento": {
    "id": 12,
    "nome": "Feijão",
    "peso": 2,
    "tipoPeso": 1,
    "quantidade": 2,
    "data_validade": "2025-12-20",
    "descricao": "Feijão delicioso",
    "imagem": "http://link.mp4",
    "id_empresa": 1
  },
  "categorias": [
    1,
    2
  ]
}
```
### ⚠️ Possível Erro (400)
Descrição: empresa ou tipo de usuário não existe
```json
{
  "status": false,
  "status_code": 404,
  "message": "Não foram encontrados itens de retorno!!!"
}
```

---

## 🛒 Pedidos 

### ✏️ Método: `POST`
### 📌 Descrição: Inserir novo pedido

---

### 📥 Exemplo de Body

```json
{
    "id_ong": 1,
    "id_alimento": 3,
    "quantidade": 2
}
```
### 📤 Exemplo de Retorno (201)
```json
{
  "status": true,
  "status_code": 201,
  "message": "Item criado com sucesso!!",
  "pedido": {
    "id": 6,
    "usuario": 1,
    "alimento": 3,
    "quantidade": 2
  }
}
```
### ⚠️ Possível Erro (400)
Descrição: usuário ou alimento não existe
```json
{
  "status": false,
  "status_code": 404,
  "message": "Não foram encontrados itens de retorno!!!"
}
```

---

## ⭐ Favoritos

### ✏️ Método: `POST`
### 📌 Descrição: Inserir nova empresa favorita

---

### 📥 Exemplo de Body

```json
{
    "id_ong": 1,
    "id_empresa": 1
}
```
### 📤 Exemplo de Retorno (201)
```json
{
  "status": true,
  "status_code": 201,
  "message": "Item criado com sucesso!!",
  "favorito": {
    "id": 3,
    "ong": 1,
    "empresa": 1
  }
}
```
### ⚠️ Possível Erro (400)
Descrição: usuário ou empresa não existe
```json
{
  "status": false,
  "status_code": 404,
  "message": "Não foram encontrados itens de retorno!!!"
}
```

---

## 📝 Filtros

### ✏️ Método: `GET`
### 📌 Descrição: buscar alimentos filtrando pela empresa, categoria ou por data

---
### Filtrar por empresa:
#### Caminho: /empresaAlimento/${id da empresa}

### 📤 Exemplo de Retorno (201)
```json
{
  "status": true,
  "status_code": 200,
  "resultFiltro": [
    {
      "id_alimento": 11,
      "nome_alimento": "Açucar refinado União",
      "quantidade": 2,
      "peso": "2",
      "id_tipo_peso": 1,
      "tipo": "Quilos(Kg)",
      "data_de_validade": "2025-12-20T00:00:00.000Z",
      "descricao": "http://foto.jpg",
      "imagem": "http://link.mp4",
      "id_empresa": 1,
      "nome_empresa": "BK",
      "foto_empresa": null,
      "nome_categoria": "SemiPerecivel"
    }
}
```

### ⚠️ Possível Erro (400)
Descrição: empresa não existe
```json
{
  "status": false,
  "status_code": 404,
  "message": "Não foram encontrados itens de retorno!!!"
}
```

### Filtrar por data:
#### Caminho: /filtroData

### 📥 Exemplo de request
curl --location 'http://localhost:8080/v1/mesa-plus/filtroData?data=20-12-2025' \
--data ''


### 📤 Exemplo de Retorno (201)
```json
{
  "status": true,
  "status_code": 200,
  "resultFiltro": [
    {
      "id_alimento": 11,
      "nome_alimento": "Açucar refinado União",
      "quantidade": 2,
      "peso": "2",
      "id_tipo_peso": 1,
      "tipo": "Quilos(Kg)",
      "data_de_validade": "2025-12-20T00:00:00.000Z",
      "descricao": "http://foto.jpg",
      "imagem": "http://link.mp4",
      "id_empresa": 1,
      "nome_empresa": "BK",
      "foto_empresa": null,
      "nome_categoria": null
    }
  ]
}
```

### ⚠️ Possível Erro (400)
Descrição: data não cadatrada
```json
{
  "status": false,
  "status_code": 404,
  "message": "Não foram encontrados itens de retorno!!!"
}
```

### Filtrar por data:
#### Caminho: /filtroCat/${id da categoria}

### 📤 Exemplo de Retorno (201)
```json
{
  "status": true,
  "status_code": 200,
  "resultFiltro": [
    {
      "id_alimento": 10,
      "nome_alimento": "Cafe Uniao",
      "quantidade": 25,
      "peso": "500",
      "id_tipo_peso": 2,
      "tipo": "Gramas(g)",
      "data_de_validade": "2025-12-25T00:00:00.000Z",
      "descricao": "otimo para começar o dia",
      "imagem": "https://mesaplustcc.blob.core.windows.net/fotos/4_1763434485383_cafer.jpeg",
      "id_empresa": 4,
      "nome_empresa": "Extra",
      "foto_empresa": null,
      "nome_categoria": "Perecivel"
    }
}
```

### ⚠️ Possível Erro (400)
Descrição: categoria não existe
```json
{
  "status": false,
  "status_code": 404,
  "message": "Não foram encontrados itens de retorno!!!"
}
```











