CREATE TABLE cliente (
                         id_cliente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                         nome VARCHAR(150) NOT NULL,
                         data_nascimento DATE NOT NULL,
                         email VARCHAR(255) NOT NULL UNIQUE,
                         data_cadastro TIMESTAMP NOT NULL,
                         canal_aquisicao VARCHAR(50) NOT NULL,
                         status_cliente VARCHAR(30) NOT NULL
);

CREATE TABLE categoria (
                           id_categoria INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                           nome VARCHAR(100) NOT NULL,
                           descricao TEXT NOT NULL,
                           status_categoria VARCHAR(30) NOT NULL,
                           sazonalidade VARCHAR(50) NOT NULL,
                           data_criacao DATE NOT NULL
);