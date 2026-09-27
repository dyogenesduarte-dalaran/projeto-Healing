ALTER TABLE cliente
    ADD CONSTRAINT chk_cliente_status
        CHECK (status_cliente IN ('ATIVO', 'INATIVO', 'BLOQUEADO'));

ALTER TABLE produto
    ADD CONSTRAINT chk_produto_status
        CHECK (status_produto IN ('ATIVO', 'INATIVO', 'DESCONTINUADO'));

ALTER TABLE produto
    ADD CONSTRAINT chk_produto_preco_atual
        CHECK (preco_atual >= 0);

ALTER TABLE produto
    ADD CONSTRAINT chk_produto_custo_referencia
        CHECK (custo_referencia >= 0);

ALTER TABLE produto
    ADD CONSTRAINT chk_produto_preco_minimo
        CHECK (preco_minimo_venda >= 0);

ALTER TABLE pedido
    ADD CONSTRAINT chk_pedido_status
        CHECK (status_pedido IN ('CRIADO', 'CONFIRMADO', 'CANCELADO', 'CONCLUIDO'));

ALTER TABLE pedido
    ADD CONSTRAINT chk_pedido_valor_bruto
        CHECK (valor_bruto >= 0);

ALTER TABLE pedido
    ADD CONSTRAINT chk_pedido_valor_desconto
        CHECK (valor_desconto >= 0);

ALTER TABLE pedido
    ADD CONSTRAINT chk_pedido_valor_final
        CHECK (valor_final >= 0);

ALTER TABLE pedido
    ADD CONSTRAINT chk_pedido_valor_reembolso
        CHECK (valor_reembolso >= 0);

ALTER TABLE pagamento
    ADD CONSTRAINT chk_pagamento_status
        CHECK (status_pagamento IN ('PENDENTE', 'APROVADO', 'NEGADO', 'CANCELADO', 'ESTORNADO'));

ALTER TABLE tentativa_pagamento
    ADD CONSTRAINT chk_tentativa_resultado
        CHECK (resultado_tentativa IN ('APROVADA', 'NEGADA'));