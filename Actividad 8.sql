-- query_01_core_retrieval.sql

-- Reporte 1: Cuentas prioritarias
SELECT account_number, account_type, balance
FROM core.accounts
WHERE balance >= 1000.00
   OR account_type = 'SAVINGS'
ORDER BY balance DESC
LIMIT 2;


-- Reporte 2: Clientes por dominio de correo
SELECT first_name, last_name, email
FROM core.customers
WHERE email ILIKE '%@email.com';


-- Reporte 3: Transacciones sin descripción
SELECT
    transaction_id,
    tx_type,
    COALESCE(
        description,
        'COBRO INSTITUCIONAL O COMISIÓN - SIN RECEPTOR'
    ) AS descripcion_visible
FROM core.transactions
WHERE description IS NULL;