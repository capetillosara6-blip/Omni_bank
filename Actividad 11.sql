-- DAY 11 - ACTIVITY

-- 1. Reporte de las cinco cuentas
-- Grano: una fila por cuenta.
-- Los datos originales se conservan; la etiqueta solo es para presentación.

SELECT
    a.account_number,
    c.email,
    a.account_type,
    a.is_active,
    CONCAT(
        UPPER(c.first_name), ' ',
        UPPER(c.last_name), ' - ****',
        RIGHT(a.account_number, 4)
    ) AS etiqueta_cuenta
FROM core.accounts a
JOIN core.customers c
    ON a.customer_id = c.customer_id
ORDER BY a.account_number;


-- 2. Reporte de los cuatro movimientos
-- Grano: una fila por movimiento.
-- Corte fijo: 2026-10-01 00:00+00.

SELECT
    t.transaction_id,
    t.account_id,
    EXTRACT(YEAR FROM t.tx_timestamp) AS anio,
    EXTRACT(MONTH FROM t.tx_timestamp) AS mes,
    TO_CHAR(t.amount, 'FM999999990.00') AS importe_presentacion,
    t.tx_timestamp AS marca_original,
    t.tx_timestamp + INTERVAL '15 days' AS fecha_revision,
    AGE(
        TIMESTAMPTZ '2026-10-01 00:00:00+00',
        t.tx_timestamp
    ) AS antiguedad_al_corte
FROM core.transactions t
WHERE t.tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00:00+00'
ORDER BY t.tx_timestamp, t.transaction_id;


-- 3. Control de cuentas
SELECT COUNT(*) AS total_cuentas
FROM core.accounts;


-- 4. Control de movimientos
SELECT COUNT(*) AS total_movimientos
FROM core.transactions;