CREATE TABLE produto (
                         id_produto INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                         id_categoria INTEGER NOT NULL,
                         nome VARCHAR(150) NOT NULL,
                         descricao TEXT NOT NULL,
                         preco_atual NUMERIC(12,2) NOT NULL,
                         custo_referencia NUMERIC(12,2) NOT NULL,
                         preco_minimo_venda NUMERIC(12,2) NOT NULL,
                         marca VARCHAR(100) NOT NULL,
                         data_lancamento DATE NOT NULL,
                         status_produto VARCHAR(30) NOT NULL,

                         FOREIGN KEY (id_categoria)
                             REFERENCES categoria(id_categoria)
);