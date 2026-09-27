-- =====================================================
-- 1. CORRIGIR DESCONTOS NEGATIVOS GERADOS NA V15
-- =====================================================

UPDATE item_pedido
SET valor_desconto_item = 0
WHERE valor_desconto_item < 0;


-- =====================================================
-- 2. RECALCULAR OS TOTAIS DOS PEDIDOS
-- =====================================================

WITH totais AS (
    SELECT
        id_pedido,

        ROUND(
                SUM(quantidade * preco_unitario),
                2
        ) AS valor_bruto_calculado,

        ROUND(
                SUM(valor_desconto_item),
                2
        ) AS valor_desconto_calculado

    FROM item_pedido

    GROUP BY id_pedido
)

UPDATE pedido p
SET
    valor_bruto = t.valor_bruto_calculado,

    valor_desconto = t.valor_desconto_calculado,

    valor_final = ROUND(
            t.valor_bruto_calculado
                - t.valor_desconto_calculado,
            2
                  ),

    valor_reembolso =
        CASE
            WHEN p.status_pedido = 'CANCELADO'
                THEN ROUND(
                    t.valor_bruto_calculado
                        - t.valor_desconto_calculado,
                    2
                     )
            ELSE 0
            END

    FROM totais t

WHERE p.id_pedido = t.id_pedido;