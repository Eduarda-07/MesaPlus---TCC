# 🥘 MESA PLUS

---

## Índice

- [Visão Geral](#visão-geral)  
- [URL base](#url-base)  
- [Respostas comuns](#respostas-comuns)  
- [Empresas](#empresas)  
- [ONGS](#ongs)  
- [Usuários](#usuarios)  

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

| Status | Status code | Mesnsagem |
|--------|-------------|-----------|
|  True  |     201     |Item criado com sucesso!!|
| False  |     400     |Não foi possível realizar a requisição, pois existem campos obrigatórios que não foram preenchidos ou não atendem a quantidade de caracteres!!!
|
| False  |     415     |Não foi possível processar a requisição, pois o tipo de dados encaminhado não é processado pelo servidor. Favor encaminhar dados apenas no formato JSON!!!
|




