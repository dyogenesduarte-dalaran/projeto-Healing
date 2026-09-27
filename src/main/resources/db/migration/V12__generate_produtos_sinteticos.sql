-- V12__generate_produtos_sinteticos.sql

-- =====================================================
-- TECNOLOGIA
-- Já existem 6 produtos.
-- Gerar mais 154 -> total 160.
-- =====================================================

INSERT INTO produto (
    id_categoria,
    nome,
    descricao,
    preco_atual,
    custo_referencia,
    preco_minimo_venda,
    marca,
    data_lancamento,
    status_produto
)
SELECT
    1,
    'Produto Tech ' || gs,
    'Produto sintético da categoria Tecnologia, criado para análises do Projeto Healing.',
    ROUND((120 + (gs * 17 % 2800))::NUMERIC, 2),
    ROUND((70 + (gs * 11 % 1500))::NUMERIC, 2),
    ROUND((85 + (gs * 13 % 1800))::NUMERIC, 2),
    CASE gs % 5
        WHEN 0 THEN 'NovaTech'
        WHEN 1 THEN 'CoreOne'
        WHEN 2 THEN 'PulseTech'
        WHEN 3 THEN 'VisionPro'
        ELSE 'SoundWave'
    END,
    DATE '2024-01-01' + (gs % 650),
    'ATIVO'
FROM generate_series(1, 154) AS gs;


-- =====================================================
-- MODA
-- Já existem 3 produtos.
-- Gerar mais 117 -> total 120.
-- =====================================================

INSERT INTO produto (
    id_categoria,
    nome,
    descricao,
    preco_atual,
    custo_referencia,
    preco_minimo_venda,
    marca,
    data_lancamento,
    status_produto
)
SELECT
    2,
    'Produto Moda ' || gs,
    'Produto sintético da categoria Moda, criado para análises do Projeto Healing.',
    ROUND((50 + (gs * 9 % 600))::NUMERIC, 2),
    ROUND((20 + (gs * 5 % 280))::NUMERIC, 2),
    ROUND((28 + (gs * 6 % 350))::NUMERIC, 2),
    CASE gs % 4
        WHEN 0 THEN 'UrbanWay'
        WHEN 1 THEN 'MoveOn'
        WHEN 2 THEN 'StyleOne'
        ELSE 'TrendLine'
    END,
    DATE '2024-01-01' + (gs % 650),
    'ATIVO'
FROM generate_series(1, 117) AS gs;


-- =====================================================
-- EDUCACAO
-- Já existem 3 produtos.
-- Gerar mais 67 -> total 70.
-- =====================================================

INSERT INTO produto (
    id_categoria,
    nome,
    descricao,
    preco_atual,
    custo_referencia,
    preco_minimo_venda,
    marca,
    data_lancamento,
    status_produto
)
SELECT
    3,
    'Produto Educacao ' || gs,
    'Produto sintético da categoria Educação, criado para análises do Projeto Healing.',
    ROUND((60 + (gs * 12 % 500))::NUMERIC, 2),
    ROUND((20 + (gs * 4 % 180))::NUMERIC, 2),
    ROUND((30 + (gs * 5 % 230))::NUMERIC, 2),
    CASE gs % 4
        WHEN 0 THEN 'LearnNow'
        WHEN 1 THEN 'DataBooks'
        WHEN 2 THEN 'EduLab'
        ELSE 'SkillUp'
    END,
    DATE '2024-01-01' + (gs % 650),
    'ATIVO'
FROM generate_series(1, 67) AS gs;


-- =====================================================
-- CASA
-- Já existem 2 produtos.
-- Gerar mais 88 -> total 90.
-- =====================================================

INSERT INTO produto (
    id_categoria,
    nome,
    descricao,
    preco_atual,
    custo_referencia,
    preco_minimo_venda,
    marca,
    data_lancamento,
    status_produto
)
SELECT
    4,
    'Produto Casa ' || gs,
    'Produto sintético da categoria Casa, criado para análises do Projeto Healing.',
    ROUND((40 + (gs * 14 % 900))::NUMERIC, 2),
    ROUND((18 + (gs * 7 % 420))::NUMERIC, 2),
    ROUND((25 + (gs * 8 % 500))::NUMERIC, 2),
    CASE gs % 4
        WHEN 0 THEN 'SmartLiving'
        WHEN 1 THEN 'CasaFlex'
        WHEN 2 THEN 'HomePlus'
        ELSE 'VivaCasa'
    END,
    DATE '2024-01-01' + (gs % 650),
    'ATIVO'
FROM generate_series(1, 88) AS gs;


-- =====================================================
-- LAZER
-- Já existe 1 produto.
-- Gerar mais 59 -> total 60.
-- =====================================================

INSERT INTO produto (
    id_categoria,
    nome,
    descricao,
    preco_atual,
    custo_referencia,
    preco_minimo_venda,
    marca,
    data_lancamento,
    status_produto
)
SELECT
    5,
    'Produto Lazer ' || gs,
    'Produto sintético da categoria Lazer, criado para análises do Projeto Healing.',
    ROUND((70 + (gs * 15 % 1100))::NUMERIC, 2),
    ROUND((30 + (gs * 8 % 500))::NUMERIC, 2),
    ROUND((40 + (gs * 9 % 600))::NUMERIC, 2),
    CASE gs % 4
        WHEN 0 THEN 'PlayMore'
        WHEN 1 THEN 'FunBox'
        WHEN 2 THEN 'SoundWave'
        ELSE 'LeisurePro'
    END,
    DATE '2024-01-01' + (gs % 650),
    'ATIVO'
FROM generate_series(1, 59) AS gs;