Actividad 10 

-- QUERY 03 - MÉTRICAS AGREGADAS

-- 1. Tablero de productos
-- Grano: una fila por tipo de cuenta activo.
-- Fuente de las medidas: core.accounts, usando balance almacenado.
SELECT
    account_type,
    COUNT(*) AS cantidad_cuentas,
    SUM(balance) AS saldo_almacenado_total,
    MIN(balance) AS saldo_almacenado_minimo,
    MAX(balance) AS saldo_almacenado_maximo,
    AVG(balance) AS saldo_almacenado_promedio
FROM core.accounts
WHERE is_active = true
GROUP BY account_type
ORDER BY saldo_almacenado_total DESC, account_type;


-- 2. Segmentación de titulares
-- Grano: una fila por titular.
SELECT
    c.email,
    COUNT(t.transaction_id) AS cantidad_movimientos,
    COALESCE(SUM(t.amount), 0) AS volumen_bruto_registrado
FROM core.customers c
LEFT JOIN core.accounts a
    ON c.customer_id = a.customer_id
LEFT JOIN core.transactions t
    ON a.account_id = t.account_id
GROUP BY c.customer_id, c.email
HAVING COUNT(t.transaction_id) >= 2
    OR COALESCE(SUM(t.amount), 0) > 100
ORDER BY volumen_bruto_registrado DESC, c.email;


-- 3. Control independiente por cuenta
-- Grano: una fila por cuenta con movimientos.
SELECT
    account_id,
    COUNT(transaction_id) AS cantidad_movimientos,
    SUM(amount) AS volumen_bruto
FROM core.transactions
GROUP BY account_id
ORDER BY account_id;


-- 4. Control general de movimientos
-- Grano: total de movimientos.
SELECT
    COUNT(transaction_id) AS total_movimientos,
    SUM(amount) AS volumen_total
FROM core.transactions;