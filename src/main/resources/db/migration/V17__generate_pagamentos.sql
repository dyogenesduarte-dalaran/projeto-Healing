-- =========================================================
-- V17 - GERAR PAGAMENTOS SINTÉTICOS
-- =========================================================


-- =========================================================
-- 1. PAGAMENTO PRINCIPAL DE TODOS OS PEDIDOS
-- =========================================================

INSERT INTO pagamento (
    id_pedido,
    forma_pagamento,
    condicao_pagamento,
    status_pagamento,
    valor_pagamento,
    valor_entrada,
    quantidade_parcelas,
    desconto_pagamento,
    taxa_pagamento,
    juros_pagamento,
    data_pagamento,
    data_confirmacao,
    data_vencimento,
    data_cancelamento,
    motivo_recusa,
    motivo_cancelamento
)
SELECT
    p.id_pedido,

    -- Forma de pagamento
    CASE p.id_pedido % 4
    WHEN 0 THEN 'PIX'
        WHEN 1 THEN 'CARTAO_CREDITO'
        WHEN 2 THEN 'CARTAO_DEBITO'
        ELSE 'BOLETO'
END AS forma_pagamento,


    -- Condição
    CASE
        WHEN p.id_pedido % 10 = 0
            THEN 'PAGAMENTO_DIVIDIDO'

        WHEN p.id_pedido % 4 = 1
            THEN 'PARCELADO'

        ELSE 'AVISTA'
END AS condicao_pagamento,


    -- Status do pagamento
    CASE
        WHEN p.status_pedido IN ('CONCLUIDO', 'CONFIRMADO')
            THEN 'APROVADO'

        WHEN p.status_pedido = 'CRIADO'
            THEN 'PENDENTE'

        WHEN p.status_pedido = 'CANCELADO'
             AND p.motivo_cancelamento = 'PAGAMENTO_NAO_APROVADO'
            THEN 'NEGADO'

        WHEN p.status_pedido = 'CANCELADO'
             AND p.motivo_cancelamento = 'CLIENTE_DESISTIU'
            THEN 'ESTORNADO'

        ELSE 'CANCELADO'
END AS status_pagamento,


    -- Em 10% dos pedidos, este pagamento representa 60% do total
    CASE
        WHEN p.id_pedido % 10 = 0
            THEN ROUND(p.valor_final * 0.60, 2)

        ELSE p.valor_final
END AS valor_pagamento,


    -- Entrada
    CASE
        WHEN p.id_pedido % 4 = 1
             AND p.id_pedido % 10 <> 0
            THEN ROUND(p.valor_final * 0.20, 2)

        ELSE NULL
END AS valor_entrada,


    -- Parcelas somente para cartão de crédito
    CASE
        WHEN p.id_pedido % 4 = 1
            THEN 2 + (p.id_pedido % 5)

        ELSE NULL
END AS quantidade_parcelas,


    0 AS desconto_pagamento,
    0 AS taxa_pagamento,
    0 AS juros_pagamento,


    -- Data em que houve interação com o pagamento
    CASE
        WHEN p.status_pedido <> 'CRIADO'
            THEN p.data_pedido + INTERVAL '10 minutes'

        ELSE NULL
END AS data_pagamento,


    -- Só pagamentos efetivamente aprovados possuem confirmação
    CASE
        WHEN p.status_pedido IN ('CONCLUIDO', 'CONFIRMADO')
            THEN p.data_pedido + INTERVAL '15 minutes'

        WHEN p.status_pedido = 'CANCELADO'
             AND p.motivo_cancelamento = 'CLIENTE_DESISTIU'
            THEN p.data_pedido + INTERVAL '15 minutes'

        ELSE NULL
END AS data_confirmacao,


    -- Vencimento para boleto
    CASE
        WHEN p.id_pedido % 4 = 3
            THEN p.data_pedido + INTERVAL '3 days'

        ELSE NULL
END AS data_vencimento,


    -- Cancelamento/estorno
    CASE
        WHEN p.status_pedido = 'CANCELADO'
            THEN p.data_cancelamento

        ELSE NULL
END AS data_cancelamento,


    -- Motivo da recusa
    CASE
        WHEN p.status_pedido = 'CANCELADO'
             AND p.motivo_cancelamento = 'PAGAMENTO_NAO_APROVADO'
            THEN 'TRANSACAO_NAO_APROVADA'

        ELSE NULL
END AS motivo_recusa,


    -- Motivo do cancelamento
    CASE
        WHEN p.status_pedido = 'CANCELADO'
             AND p.motivo_cancelamento <> 'PAGAMENTO_NAO_APROVADO'
            THEN p.motivo_cancelamento

        ELSE NULL
END AS motivo_cancelamento

FROM pedido p;



-- =========================================================
-- 2. SEGUNDO PAGAMENTO PARA CERCA DE 10% DOS PEDIDOS
-- =========================================================

INSERT INTO pagamento (
    id_pedido,
    forma_pagamento,
    condicao_pagamento,
    status_pagamento,
    valor_pagamento,
    valor_entrada,
    quantidade_parcelas,
    desconto_pagamento,
    taxa_pagamento,
    juros_pagamento,
    data_pagamento,
    data_confirmacao,
    data_vencimento,
    data_cancelamento,
    motivo_recusa,
    motivo_cancelamento
)
SELECT
    p.id_pedido,

    -- Segunda forma diferente da primeira
    CASE p.id_pedido % 3
    WHEN 0 THEN 'PIX'
        WHEN 1 THEN 'CARTAO_DEBITO'
        ELSE 'CARTAO_CREDITO'
END,

    'PAGAMENTO_DIVIDIDO',

    CASE
        WHEN p.status_pedido IN ('CONCLUIDO', 'CONFIRMADO')
            THEN 'APROVADO'

        WHEN p.status_pedido = 'CRIADO'
            THEN 'PENDENTE'

        WHEN p.status_pedido = 'CANCELADO'
             AND p.motivo_cancelamento = 'PAGAMENTO_NAO_APROVADO'
            THEN 'NEGADO'

        WHEN p.status_pedido = 'CANCELADO'
             AND p.motivo_cancelamento = 'CLIENTE_DESISTIU'
            THEN 'ESTORNADO'

        ELSE 'CANCELADO'
END,

    -- Segunda parte = 40%
    ROUND(p.valor_final * 0.40, 2),

    NULL,

    CASE
        WHEN p.id_pedido % 3 = 2
            THEN 2 + (p.id_pedido % 5)

        ELSE NULL
END,

    0,
    0,
    0,

    CASE
        WHEN p.status_pedido <> 'CRIADO'
            THEN p.data_pedido + INTERVAL '12 minutes'

        ELSE NULL
END,

    CASE
        WHEN p.status_pedido IN ('CONCLUIDO', 'CONFIRMADO')
            THEN p.data_pedido + INTERVAL '17 minutes'

        WHEN p.status_pedido = 'CANCELADO'
             AND p.motivo_cancelamento = 'CLIENTE_DESISTIU'
            THEN p.data_pedido + INTERVAL '17 minutes'

        ELSE NULL
END,

    NULL,

    CASE
        WHEN p.status_pedido = 'CANCELADO'
            THEN p.data_cancelamento

        ELSE NULL
END,

    CASE
        WHEN p.status_pedido = 'CANCELADO'
             AND p.motivo_cancelamento = 'PAGAMENTO_NAO_APROVADO'
            THEN 'TRANSACAO_NAO_APROVADA'

        ELSE NULL
END,

    CASE
        WHEN p.status_pedido = 'CANCELADO'
             AND p.motivo_cancelamento <> 'PAGAMENTO_NAO_APROVADO'
            THEN p.motivo_cancelamento

        ELSE NULL
END

FROM pedido p

WHERE p.id_pedido % 10 = 0;