-- DAY 11 - HOMEWORK

-- 1. Porcentaje de cuentas desactivadas
-- Grano: una fila con el indicador general.
-- Se usa división numérica para conservar los decimales.

SELECT
    COUNT(*) AS cuentas_totales,
    COUNT(*) FILTER (WHERE is_active = false) AS cuentas_desactivadas,
    ROUND(
        COUNT(*) FILTER (WHERE is_active = false)::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS porcentaje_desactivadas
FROM core.accounts;


-- 2. Antigüedad de los movimientos
-- Grano: una fila por movimiento.
-- Corte fijo: 2026-10-01 00:00+00.
-- La fecha de revisión se calcula sin modificar tx_timestamp.

SELECT
    t.transaction_id,
    t.tx_timestamp AS marca_original,
    t.tx_timestamp + INTERVAL '15 days' AS fecha_revision,
    AGE(
        TIMESTAMPTZ '2026-10-01 00:00:00+00',
        t.tx_timestamp
    ) AS antiguedad_al_corte
FROM core.transactions t
WHERE t.tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00:00+00'
ORDER BY t.tx_timestamp, t.transaction_id;


-- 3. Verificación de los recuentos
SELECT
    COUNT(*) AS cuentas_totales,
    COUNT(*) FILTER (WHERE is_active = false) AS cuentas_desactivadas
FROM core.accounts;