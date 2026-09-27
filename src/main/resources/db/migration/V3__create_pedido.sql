CREATE TABLE pedido (
                        id_pedido INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                        id_cliente INTEGER NOT NULL,
                        data_pedido TIMESTAMP NOT NULL,
                        status_pedido VARCHAR(30) NOT NULL,
                        canal_venda VARCHAR(50) NOT NULL,
                        origem_pedido VARCHAR(80) NOT NULL,
                        valor_bruto NUMERIC(12,2) NOT NULL,
                        valor_desconto NUMERIC(12,2) NOT NULL,
                        valor_final NUMERIC(12,2) NOT NULL,
                        codigo_cupom VARCHAR(50),
                        data_cancelamento TIMESTAMP,
                        motivo_cancelamento VARCHAR(255),
                        valor_reembolso NUMERIC(12,2) NOT NULL,

                        FOREIGN KEY (id_cliente)
                            REFERENCES cliente(id_cliente)
);