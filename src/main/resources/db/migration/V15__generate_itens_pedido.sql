WITH produto_x AS (
    SELECT id_produto
    FROM produto
    WHERE nome = 'Smartwatch Pulse X'
),

     itens_base AS (
         SELECT
             pe.id_pedido,
             item.numero_item,

             CASE
                 -- Cerca de 20% dos pedidos terão o Produto X
                 WHEN pe.id_pedido % 5 = 0
                 AND item.numero_item = 1
    THEN px.id_produto

    ELSE
    CASE
    WHEN (((pe.id_pedido * 31)
    + (item.numero_item * 17)) % 500) + 1 = px.id_produto
    THEN
    CASE
    WHEN px.id_produto = 500 THEN 1
    ELSE px.id_produto + 1
END

ELSE
                        (((pe.id_pedido * 31)
                          + (item.numero_item * 17)) % 500) + 1
END
END AS id_produto,

        1 + ((pe.id_pedido + item.numero_item) % 3) AS quantidade

    FROM pedido pe

    CROSS JOIN produto_x px

    CROSS JOIN LATERAL generate_series(
        1,
        2 + (pe.id_pedido % 4)
    ) AS item(numero_item)
),

itens_produto AS (
    SELECT
        ib.id_pedido,
        ib.id_produto,
        ib.quantidade,

        p.preco_atual,
        p.custo_referencia,
        p.preco_minimo_venda,

        CASE
            WHEN (ib.id_pedido + ib.id_produto) % 20 = 0
                THEN 'PRECO_MINIMO'

            WHEN (ib.id_pedido + ib.id_produto) % 10 = 0
                THEN 'NEGOCIADO'

            WHEN (ib.id_pedido + ib.id_produto) % 5 = 0
                THEN 'PROMOCIONAL'

            ELSE 'NORMAL'
        END AS tipo_preco

    FROM itens_base ib

    JOIN produto p
        ON p.id_produto = ib.id_produto
)

INSERT INTO item_pedido (
    id_pedido,
    id_produto,
    quantidade,
    preco_unitario,
    custo_unitario_referencia,
    preco_minimo_referencia,
    valor_desconto_item,
    tipo_preco
)
SELECT
    id_pedido,
    id_produto,
    quantidade,

    preco_atual,

    custo_referencia,

    preco_minimo_venda,

    CASE
        WHEN tipo_preco = 'PRECO_MINIMO'
            THEN ROUND(
                (preco_atual - preco_minimo_venda)
                    * quantidade,
                2
                 )

        WHEN tipo_preco = 'NEGOCIADO'
            THEN ROUND(
                preco_atual
                    * quantidade
                    * 0.15,
                2
                 )

        WHEN tipo_preco = 'PROMOCIONAL'
            THEN ROUND(
                preco_atual
                    * quantidade
                    * 0.10,
                2
                 )

        ELSE 0
        END AS valor_desconto_item,

    tipo_preco

FROM itens_produto;