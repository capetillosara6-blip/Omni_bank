-- 1. Métricas de movimientos
-- Grano: una fila por cuenta que tiene movimientos.
-- El volumen es la suma de importes, no el saldo.

WITH metricas_movimientos AS (
    SELECT
        account_id,
        COUNT(transaction_id) AS cantidad_eventos,
        SUM(amount) AS volumen_bruto
    FROM core.transactions
    GROUP BY account_id
),

-- 2. Todas las cuentas activas
-- Grano: una fila por cuenta activa.
-- Las cuentas sin movimientos conservan sus datos con ceros.

cuentas_activas AS (
    SELECT
        a.account_id,
        a.account_number,
        a.customer_id,
        a.currency_type,
        COALESCE(m.cantidad_eventos, 0) AS cantidad_eventos,
        COALESCE(m.volumen_bruto, 0) AS volumen_bruto
    FROM core.accounts a
    LEFT JOIN metricas_movimientos m
        ON a.account_id = m.account_id
    WHERE a.is_active = true
),

-- 3. Reporte final por cuenta
-- Grano: una fila por cuenta activa, vinculada a su titular.

reporte_cuentas AS (
    SELECT
        ca.account_id,
        ca.account_number,
        c.first_name,
        c.last_name,
        c.email,
        ca.currency_type,
        ca.cantidad_eventos,
        ca.volumen_bruto,
        CASE
            WHEN ca.cantidad_eventos = 0 THEN 'Sin actividad'
            WHEN ca.cantidad_eventos = 1 THEN 'Actividad baja'
            ELSE 'Actividad alta'
        END AS banda_actividad
    FROM cuentas_activas ca
    JOIN core.customers c
        ON ca.customer_id = c.customer_id
)

SELECT
    account_number,
    first_name,
    last_name,
    email,
    currency_type,
    cantidad_eventos,
    volumen_bruto,
    banda_actividad
FROM reporte_cuentas
ORDER BY account_number;


-- 4. Control directo: cantidad de cuentas activas
SELECT COUNT(*) AS cuentas_activas
FROM core.accounts
WHERE is_active = true;


-- 5. Control directo: volumen bruto de movimientos
SELECT
    COUNT(transaction_id) AS total_eventos,
    SUM(amount) AS volumen_bruto_total
FROM core.transactions;