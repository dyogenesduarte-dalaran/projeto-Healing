CREATE TABLE item_pedido (
                             id_item_pedido INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                             id_pedido INTEGER NOT NULL,
                             id_produto INTEGER NOT NULL,
                             quantidade INTEGER NOT NULL,
                             preco_unitario NUMERIC(12,2) NOT NULL,
                             custo_unitario_referencia NUMERIC(12,2) NOT NULL,
                             preco_minimo_referencia NUMERIC(12,2) NOT NULL,
                             valor_desconto_item NUMERIC(12,2) NOT NULL,
                             tipo_preco VARCHAR(30) NOT NULL,

                             CONSTRAINT chk_item_pedido_quantidade
                                 CHECK (quantidade > 0),

                             FOREIGN KEY (id_pedido)
                                 REFERENCES pedido(id_pedido),

                             FOREIGN KEY (id_produto)
                                 REFERENCES produto(id_produto)
);