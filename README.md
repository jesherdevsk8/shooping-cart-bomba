# **README - Como Rodar a Aplicação**

Este documento fornece informações sobre como rodar a aplicação, tanto com o Docker quanto no ambiente local, e inclui as dependências necessárias e a configuração do ambiente.

---

## **Dependências**

A aplicação foi desenvolvida com as seguintes dependências:

- **Ruby**: 3.3.1
- **Rails**: 7.1.3.2
- **PostgreSQL**: 16
- **Redis**: 6.2.6

---

## **Configuração do Ambiente**
- dado as dependencias rodar os comandos
```bash
mv env-example .env
bin/rails db:create db:migrate db:seed
bin/setup
bin/dev
```

---

## **Docker**

- rodar os comandos
```bash
docker compose up --build -d
docker compose attach web
```

## **Documentação da Aplicação**

## Api rodando em produção com dados fakes para teste
## products root path
GET https://livro-caixa-shooping-cart-bomba.oz9uws.easypanel.host

## listar itens dentro do carrinho de compras
GET https://livro-caixa-shooping-cart-bomba.oz9uws.easypanel.host/cart

## adicionar item dentro do carrinho de compras
POST https://livro-caixa-shooping-cart-bomba.oz9uws.easypanel.host/cart
```json
{
  "product_id": 2,
  "quantity": 3
}
```

- retorna not found quando o produto n o  encontrado no carrinho
```json
{
	"error": "Produto não encontrado"
}
```

- retorna solicitação inválida quando a quantidade não é informada

```json
{
	"error": "Quantidade inválida"
}
```

## atualizar quantidade do item dentro do carrinho de compras
PATCH https://livro-caixa-shooping-cart-bomba.oz9uws.easypanel.host/cart/add_item
```json
{
  "product_id": 2,
  "quantity": 1
}
```

- retorna not found quando o produto n o  encontrado no carrinho
```json
{
	"error": "Produto não encontrado"
}
```

- retorna solicitação inválida quando a quantidade não é informada

```json
{
	"error": "Quantidade inválida"
}
```

## Remover item dentro do carrinho de compras */cart/:product_id*
DELETE https://livro-caixa-shooping-cart-bomba.oz9uws.easypanel.host/cart/2
```json
{
	"message": "Item removido do carrinho"
}
```
