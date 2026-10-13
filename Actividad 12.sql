-- 1. Movimientos superiores al promedio de su propia cuenta
-- Grano: una fila por movimiento que supera el promedio de su cuenta.
-- La subconsulta se relaciona con la cuenta de la fila externa.

SELECT
    t.transaction_id,
    t.account_id,
    t.amount,
    (
        SELECT AVG(t2.amount)
        FROM core.transactions t2
        WHERE t2.account_id = t.account_id
    ) AS promedio_de_su_cuenta
FROM core.transactions t
WHERE t.amount > (
    SELECT AVG(t2.amount)
    FROM core.transactions t2
    WHERE t2.account_id = t.account_id
)
ORDER BY t.account_id, t.tx_timestamp, t.transaction_id;


-- 2. Promedio agrupado de control
-- Grano: una fila por cuenta con movimientos.
-- Sirve para comprobar el promedio calculado en la consulta anterior.

SELECT
    account_id,
    AVG(amount) AS promedio_de_la_cuenta
FROM core.transactions
GROUP BY account_id
ORDER BY account_id;


-- 3. Cuentas sin movimientos
-- Grano: una fila por cuenta sin eventos.
-- Se revisan las cinco cuentas, sin filtrar por is_active.

SELECT
    a.account_number,
    a.is_active
FROM core.accounts a
WHERE NOT EXISTS (
    SELECT 1
    FROM core.transactions t
    WHERE t.account_id = a.account_id
)
ORDER BY a.account_number;