INSERT INTO cliente (
    nome,
    data_nascimento,
    email,
    data_cadastro,
    canal_aquisicao,
    status_cliente
)
SELECT
    'Cliente Sintetico ' || LPAD(gs::TEXT, 4, '0'),

    DATE '1965-01-01'
        + ((gs * 37) % 15000),

    'cliente' || LPAD(gs::TEXT, 4, '0') || '@healing.com',

    TIMESTAMP '2026-02-01 08:00:00'
    + ((gs % 180) * INTERVAL '1 day')
    + ((gs % 12) * INTERVAL '1 hour'),

    CASE gs % 5
    WHEN 0 THEN 'INSTAGRAM'
    WHEN 1 THEN 'GOOGLE_ADS'
    WHEN 2 THEN 'ORGANICO'
    WHEN 3 THEN 'INDICACAO'
    ELSE 'EMAIL_MARKETING'
END,

    CASE
        WHEN gs % 20 = 0 THEN 'BLOQUEADO'
        WHEN gs % 20 IN (1, 2, 3) THEN 'INATIVO'
        ELSE 'ATIVO'
END

FROM generate_series(1, 1990) AS gs;