
# Desafio técnico - Shopping Cart - RDStation

## O que foi implementado

Esta aplicação é uma API de gerenciamento de carrinho de compras para um e-commerce, desenvolvida em Ruby on Rails. A seguir estão as funcionalidades que foram implementadas com sucesso:

- **Registrar um produto no carrinho**: Criado o endpoint `/cart` para registrar produtos no carrinho de compras, com a lógica para criar um carrinho novo caso não exista um para a sessão.
- **Listar itens do carrinho atual**: Implementado o endpoint `/cart` para listar todos os produtos do carrinho atual, com os dados necessários como nome, quantidade, preço unitário e preço total.
- **Alterar a quantidade de produtos no carrinho**: Criado o endpoint `/cart/add_item` para atualizar a quantidade de um produto já presente no carrinho.
- **Remover um produto do carrinho**: Implementado o endpoint `/cart/:product_id` para remover um produto específico do carrinho.
- **Excluir carrinhos abandonados**: Implementado um job para verificar e marcar carrinhos como abandonados após 3 horas de inatividade e excluí-los após 7 dias.

### Detalhes sobre o que falta implementar

- **Docker**: O Dockerfile está presente no projeto, mas a configuração do `docker-compose.yml` ainda precisa ser feita para completar a dockerização da aplicação. Embora a aplicação funcione sem Docker, seria necessário esse passo para garantir a execução correta em contêineres.

## Como executar o projeto

### Requisitos

- Ruby 3.3.1
- Rails 7.1.3.2
- PostgreSQL 16
- Redis 7.0.15

### Executando a app sem Docker

1. Instale as dependências do projeto:
    ```bash
    bundle install
    ```

2. Execute o Sidekiq:
    ```bash
    bundle exec sidekiq
    ```

3. Execute o servidor Rails:
    ```bash
    bundle exec rails server
    ```

4. Para rodar os testes:
    ```bash
    bundle exec rspec
    ```


## Funcionalidades Implementadas

### 1. Registrar um produto no carrinho

**ROTA**: `/cart`  
**Payload**:
```json
{
  "product_id": 345,
  "quantity": 2
}
```
**Response**:
```json
{
  "id": 789,
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    }
  ],
  "total_price": 7.96
}
```

### 2. Listar itens do carrinho atual

**ROTA**: `/cart`  
**Response**:
```json
{
  "id": 789,
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98
    }
  ],
  "total_price": 7.96
}
```

### 3. Alterar a quantidade de produtos no carrinho

**ROTA**: `/cart/add_item`  
**Payload**:
```json
{
  "product_id": 1230,
  "quantity": 1
}
```
**Response**:
```json
{
  "id": 1,
  "products": [
    {
      "id": 1230,
      "name": "Nome do produto X",
      "quantity": 2,
      "unit_price": 7.00,
      "total_price": 14.00
    },
    {
      "id": 01020,
      "name": "Nome do produto Y",
      "quantity": 1,
      "unit_price": 9.90,
      "total_price": 9.90
    }
  ],
  "total_price": 23.90
}
```

### 4. Remover um produto do carrinho

**ROTA**: `/cart/:product_id`

### 5. Excluir carrinhos abandonados

- Carrinhos que não tiveram interação por mais de 3 horas são marcados como abandonados.
- Carrinhos abandonados por mais de 7 dias são removidos.
- Um job foi implementado para verificar e realizar essas ações.

---
