# Projeto Healing — Mentoria em Dados

O Projeto Healing é uma jornada prática de aprendizado e construção de portfólio voltada para a área de Dados.

O projeto utilizará um e-commerce fictício como cenário de estudo, permitindo desenvolver conhecimentos de modelagem de dados, banco de dados relacional, SQL, PostgreSQL, análise de dados e Power BI.

Posteriormente, o projeto também poderá incorporar Python e Pandas.

## Objetivo

Construir gradualmente uma solução de dados capaz de representar e analisar o funcionamento de um e-commerce fictício.

O foco não é apenas criar um sistema pronto, mas compreender cada etapa do processo:

Modelagem do negócio → Banco de Dados → PostgreSQL → SQL → Análise de Dados → Power BI → Python/Pandas.

## Tecnologias e conhecimentos

* SQL
* PostgreSQL
* Modelagem de Dados
* Análise de Dados
* Power BI
* Python e Pandas futuramente

Java e Spring Boot fazem parte da formação complementar, mas não são o foco principal deste projeto.

## Contexto do negócio

O cenário será um e-commerce fictício no qual clientes realizam pedidos contendo diferentes produtos.

A análise será orientada principalmente pelo comportamento das vendas geradas pelos pedidos.

## Entidades identificadas inicialmente

* Cliente
* Produto
* Categoria
* Pedido
* ItemPedido
* Pagamento
* Estoque
* Entrega

A modelagem ainda está em desenvolvimento e poderá sofrer alterações conforme o entendimento do negócio evoluir.

## Relacionamentos iniciais

* Cliente realiza Pedido
* Pedido possui ItemPedido
* Produto aparece em ItemPedido
* Categoria possui Produtos
* Pedido possui Pagamento
* Produto possui Estoque
* Pedido possui Entrega

## Perguntas de negócio

O projeto deverá futuramente permitir responder perguntas como:

* Quais produtos vendem mais?
* Quais categorias geram maior faturamento?
* Qual é o ticket médio?
* Quais clientes compram mais?
* Como as vendas evoluem ao longo do tempo?
* Quais produtos apresentam estoque baixo?
* Quais formas de pagamento são mais utilizadas?
* Quais regiões apresentam maior faturamento?

## Análises futuras

Entre as análises planejadas está a classificação de produtos utilizando a Curva ABC.

A classificação poderá considerar critérios como quantidade vendida ou faturamento gerado por produto.

A Curva ABC será tratada como resultado de análise dos dados de vendas, e não inicialmente como um atributo fixo dos produtos.

## Status atual

O projeto encontra-se na fase de:

**Definição do negócio e modelagem conceitual inicial.**

Nenhuma estrutura definitiva de banco de dados foi implementada até o momento.
