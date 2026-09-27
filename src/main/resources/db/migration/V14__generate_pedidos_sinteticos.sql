WITH pedidos_base AS (
    SELECT
        gs,

        ((gs * 17) % 2000) + 1 AS id_cliente,

    TIMESTAMP '2026-03-01 08:00:00'
    + ((gs % 210) * INTERVAL '1 day')
    + ((gs % 12) * INTERVAL '1 hour')
    + ((gs % 60) * INTERVAL '1 minute') AS data_pedido,

    CASE
    WHEN gs % 100 < 75 THEN 'CONCLUIDO'
    WHEN gs % 100 < 87 THEN 'CONFIRMADO'
    WHEN gs % 100 < 95 THEN 'CANCELADO'
    ELSE 'CRIADO'
END AS status_pedido,

        CASE gs % 3
            WHEN 0 THEN 'SITE'
            WHEN 1 THEN 'APP'
            ELSE 'MARKETPLACE'
END AS canal_venda,

        CASE gs % 5
            WHEN 0 THEN 'GOOGLE_ADS'
            WHEN 1 THEN 'INSTAGRAM'
            WHEN 2 THEN 'ORGANICO'
            WHEN 3 THEN 'INDICACAO'
            ELSE 'EMAIL_MARKETING'
END AS origem_pedido,

        ROUND(
            (120 + ((gs * 37) % 2200))::NUMERIC,
            2
        ) AS valor_bruto

    FROM generate_series(1, 12000) AS gs
),

pedidos_com_desconto AS (
    SELECT
        *,

        CASE
            WHEN gs % 4 = 0 THEN
                ROUND(
                    valor_bruto *
                    (0.05 + ((gs % 16) / 100.0)),
                    2
                )
            ELSE 0
        END AS valor_desconto

    FROM pedidos_base
)

INSERT INTO pedido (
    id_cliente,
    data_pedido,
    status_pedido,
    canal_venda,
    origem_pedido,
    valor_bruto,
    valor_desconto,
    valor_final,
    codigo_cupom,
    data_cancelamento,
    motivo_cancelamento,
    valor_reembolso
)
SELECT
    id_cliente,
    data_pedido,
    status_pedido,
    canal_venda,
    origem_pedido,
    valor_bruto,
    valor_desconto,

    ROUND(
            valor_bruto - valor_desconto,
            2
    ) AS valor_final,

    CASE
        WHEN valor_desconto > 0
            THEN 'CUPOM' || LPAD((gs % 20)::TEXT, 2, '0')
        ELSE NULL
        END AS codigo_cupom,

    CASE
        WHEN status_pedido = 'CANCELADO'
            THEN data_pedido + INTERVAL '1 day'
    ELSE NULL
END AS data_cancelamento,

    CASE
        WHEN status_pedido = 'CANCELADO'
            THEN CASE gs % 4
                WHEN 0 THEN 'CLIENTE_DESISTIU'
                WHEN 1 THEN 'PAGAMENTO_NAO_APROVADO'
                WHEN 2 THEN 'DUPLICIDADE'
                ELSE 'ERRO_NO_PEDIDO'
END
ELSE NULL
END AS motivo_cancelamento,

    CASE
        WHEN status_pedido = 'CANCELADO'
            THEN ROUND(valor_bruto - valor_desconto, 2)
        ELSE 0
END AS valor_reembolso

FROM pedidos_com_desconto;