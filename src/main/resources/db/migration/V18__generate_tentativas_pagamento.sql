-- =========================================================
-- V18 - GERAR TENTATIVAS DE PAGAMENTO
-- =========================================================


-- =========================================================
-- 1. PRIMEIRA TENTATIVA PARA TODOS OS PAGAMENTOS
-- =========================================================

INSERT INTO tentativa_pagamento (
    id_pagamento,
    data_hora_tentativa,
    resultado_tentativa,
    motivo_recusa
)
SELECT
    pg.id_pagamento,

    COALESCE(
            pg.data_pagamento,
            p.data_pedido + INTERVAL '5 minutes'
    ) AS data_hora_tentativa,

    CASE
        WHEN pg.status_pagamento IN ('APROVADO', 'ESTORNADO')
            THEN 'APROVADA'

        WHEN pg.status_pagamento = 'NEGADO'
            THEN 'NEGADA'

        WHEN pg.status_pagamento = 'CANCELADO'
            THEN 'NEGADA'

        ELSE 'NEGADA'
        END AS resultado_tentativa,

    CASE
        WHEN pg.status_pagamento IN ('APROVADO', 'ESTORNADO')
            THEN NULL

        WHEN pg.status_pagamento = 'NEGADO'
            THEN COALESCE(
                pg.motivo_recusa,
                'TRANSACAO_NAO_APROVADA'
                 )

        WHEN pg.status_pagamento = 'CANCELADO'
            THEN 'PROCESSAMENTO_CANCELADO'

        ELSE 'PAGAMENTO_PENDENTE'
        END AS motivo_recusa

FROM pagamento pg

         JOIN pedido p
              ON p.id_pedido = pg.id_pedido;



-- =========================================================
-- 2. SEGUNDA TENTATIVA PARA PARTE DOS PAGAMENTOS NEGADOS
-- =========================================================

INSERT INTO tentativa_pagamento (
    id_pagamento,
    data_hora_tentativa,
    resultado_tentativa,
    motivo_recusa
)
SELECT
    pg.id_pagamento,

    COALESCE(
            pg.data_pagamento,
            p.data_pedido
    ) + INTERVAL '2 minutes',

    'NEGADA',

    CASE pg.id_pagamento % 3
    WHEN 0 THEN 'LIMITE_INSUFICIENTE'
    WHEN 1 THEN 'DADOS_INVALIDOS'
    ELSE 'TRANSACAO_NAO_AUTORIZADA'
END

FROM pagamento pg

JOIN pedido p
    ON p.id_pedido = pg.id_pedido

WHERE pg.status_pagamento = 'NEGADO';



-- =========================================================
-- 3. SIMULAR CASOS DE PRIMEIRA RECUSA E SEGUNDA APROVAÇÃO
-- =========================================================

INSERT INTO tentativa_pagamento (
    id_pagamento,
    data_hora_tentativa,
    resultado_tentativa,
    motivo_recusa
)
SELECT
    pg.id_pagamento,

    pg.data_pagamento - INTERVAL '2 minutes',

    'NEGADA',

    CASE pg.id_pagamento % 3
    WHEN 0 THEN 'DADOS_INVALIDOS'
    WHEN 1 THEN 'TRANSACAO_NAO_AUTORIZADA'
    ELSE 'FALHA_TEMPORARIA'
END

FROM pagamento pg

WHERE pg.status_pagamento = 'APROVADO'
  AND pg.id_pagamento % 10 = 0;