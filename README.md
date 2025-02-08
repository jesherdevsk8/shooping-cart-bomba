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
bin/rails db:create db:migrate db:seed
bin/setup
bin/dev