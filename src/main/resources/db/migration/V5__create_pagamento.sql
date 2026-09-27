CREATE TABLE pagamento (
                           id_pagamento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                           id_pedido INTEGER NOT NULL,
                           forma_pagamento VARCHAR(30) NOT NULL,
                           condicao_pagamento VARCHAR(50) NOT NULL,
                           status_pagamento VARCHAR(30) NOT NULL,
                           valor_pagamento NUMERIC(12,2) NOT NULL,
                           valor_entrada NUMERIC(12,2),
                           quantidade_parcelas INTEGER,
                           desconto_pagamento NUMERIC(12,2) NOT NULL,
                           taxa_pagamento NUMERIC(12,2) NOT NULL,
                           juros_pagamento NUMERIC(12,2) NOT NULL,
                           data_pagamento TIMESTAMP,
                           data_confirmacao TIMESTAMP,
                           data_vencimento TIMESTAMP,
                           data_cancelamento TIMESTAMP,
                           motivo_recusa VARCHAR(255),
                           motivo_cancelamento VARCHAR(255),

                           CONSTRAINT chk_pagamento_valor
                               CHECK (valor_pagamento > 0),

                           CONSTRAINT chk_pagamento_parcelas
                               CHECK (quantidade_parcelas IS NULL OR quantidade_parcelas > 0),

                           CONSTRAINT chk_pagamento_desconto
                               CHECK (desconto_pagamento >= 0),

                           CONSTRAINT chk_pagamento_taxa
                               CHECK (taxa_pagamento >= 0),

                           CONSTRAINT chk_pagamento_juros
                               CHECK (juros_pagamento >= 0),

                           FOREIGN KEY (id_pedido)
                               REFERENCES pedido(id_pedido)
);