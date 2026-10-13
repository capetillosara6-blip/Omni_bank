-- 1. Conteo cartesiano
-- Grano: producto de todas las combinaciones posibles entre las tres tablas.
SELECT
    COUNT(*) AS producto_cartesiano
FROM core.customers c
CROSS JOIN core.accounts a
CROSS JOIN core.transactions t;
-- Cada combinación une cualquier cliente con cualquier cuenta y movimiento,
-- por lo que muchas combinaciones son falsas para el negocio.
-- 2. Reporte corregido de movimientos
-- Grano: una fila por movimiento relacionado con su cuenta y titular.
SELECT
    c.email,
    a.account_number,
    t.tx_type,
    t.amount,
    t.tx_timestamp
FROM core.transactions t
JOIN core.accounts a
    ON t.account_id = a.account_id
JOIN core.customers c
    ON a.customer_id = c.customer_id
WHERE c.is_active = true
  AND t.amount >= 100
ORDER BY t.tx_timestamp, t.transaction_id;