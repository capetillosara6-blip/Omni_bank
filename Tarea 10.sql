-- DAY 10 - HOMEWORK
-- 1. Muestra nullable
-- Grano: una fila por valor de prueba.
-- La muestra no representa saldos reales.
WITH muestra AS (
    SELECT *
    FROM (VALUES
        (10000::NUMERIC),
        (0::NUMERIC),
        (0::NUMERIC),
        (NULL::NUMERIC)
    ) AS v(valor)
)
SELECT
    AVG(valor) AS promedio_sin_coalesce,
    COUNT(valor) AS denominador_sin_coalesce,
    AVG(COALESCE(valor, 0)) AS promedio_con_coalesce,
    COUNT(*) AS denominador_con_coalesce
FROM muestra;
-- 2. Reporte de cuentas CREDIT activas
SELECT
    a.account_number,
    a.balance AS saldo_almacenado,
    COUNT(t.transaction_id) AS cantidad_movimientos,
    COALESCE(SUM(t.amount), 0) AS volumen_bruto_registrado
FROM core.accounts a
LEFT JOIN core.transactions t
    ON a.account_id = t.account_id
WHERE a.account_type = 'CREDIT'
  AND a.is_active = true
GROUP BY a.account_id, a.account_number, a.balance
HAVING COUNT(t.transaction_id) = 0
    OR COALESCE(SUM(t.amount), 0) >= 300
ORDER BY a.account_number;
