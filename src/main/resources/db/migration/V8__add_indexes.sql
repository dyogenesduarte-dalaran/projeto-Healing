CREATE INDEX idx_pedido_id_cliente
    ON pedido(id_cliente);

CREATE INDEX idx_produto_id_categoria
    ON produto(id_categoria);

CREATE INDEX idx_item_pedido_id_pedido
    ON item_pedido(id_pedido);

CREATE INDEX idx_item_pedido_id_produto
    ON item_pedido(id_produto);

CREATE INDEX idx_pagamento_id_pedido
    ON pagamento(id_pedido);

CREATE INDEX idx_tentativa_pagamento_id_pagamento
    ON tentativa_pagamento(id_pagamento);