WITH metricas_movimientos AS (
    -- Grano: una fila por cuenta que tiene movimientos.
    SELECT
        account_id,
        COUNT(transaction_id) AS cantidad_eventos,
        SUM(amount) AS volumen_bruto
    FROM core.transactions
    GROUP BY account_id
),
cuentas_activas AS (
    SELECT
        a.account_id,
        a.account_number,
        a.currency_type,
        COALESCE(m.cantidad_eventos, 0) AS cantidad_eventos,
        COALESCE(m.volumen_bruto, 0) AS volumen_bruto
    FROM core.accounts AS a
    LEFT JOIN metricas_movimientos AS m
        ON m.account_id = a.account_id
    WHERE a.is_active = TRUE
),
resumen_por_moneda AS (
    -- Cambio de grano: una fila por moneda.
    -- El promedio incluye todas las cuentas activas, incluso las de volumen cero.
    SELECT
        currency_type,
        COUNT(account_id) AS numero_cuentas,
        SUM(volumen_bruto) AS volumen_bruto_total,
        AVG(volumen_bruto) AS promedio_sin_redondear
    FROM cuentas_activas
    GROUP BY currency_type
)
SELECT
    currency_type,
    numero_cuentas,
    volumen_bruto_total,
    ROUND(promedio_sin_redondear, 2) AS promedio_volumen_por_cuenta
FROM resumen_por_moneda
ORDER BY currency_type;

COMPROBACIONES INDEPENDIENTES

SELECT COUNT(*) AS cuentas_activas
FROM core.accounts
WHERE is_active = TRUE;

SELECT
    COUNT(transaction_id) AS cantidad_movimientos,
    SUM(amount) AS volumen_bruto_total
FROM core.transactions;

WITH metricas_movimientos AS (
    SELECT
        account_id,
        COUNT(transaction_id) AS cantidad_eventos,
        SUM(amount) AS volumen_bruto
    FROM core.transactions
    GROUP BY account_id
)
SELECT
    a.account_number,
    a.is_active,
    COALESCE(m.cantidad_eventos, 0) AS cantidad_eventos,
    COALESCE(m.volumen_bruto, 0) AS volumen_bruto
FROM core.accounts AS a
LEFT JOIN metricas_movimientos AS m
    ON m.account_id = a.account_id
WHERE a.account_number = 'ACCT-3002';