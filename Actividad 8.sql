-- REPORTE 1: Extracción Quirúrgica de Cuentas Prioritarias en OmniBank
-- Excluye celdas ruidosas (UUIDs, created_at, etc.) mediante proyección explícita
SELECT 
    account_number,
    account_type,
    balance
FROM core.accounts
WHERE (balance >= 1000.00 OR account_type = 'SAVINGS')
ORDER BY balance DESC
LIMIT 2;

-- REPORTE 2: Búsqueda Insensible por Patrones en Clientes Bancarios
-- Atrapa por igual '@email.com', '@EMAIL.COM' sin alterar el motor
SELECT 
    first_name,
    last_name,
    email
FROM core.customers
WHERE email ILIKE '%@email.com';

-- REPORTE 3: Resolución de la Lógica Tri-Valuada y Salvaguarda con COALESCE
-- Corrige el fallo del analista interino (= NULL -> IS NULL) y purga vacíos
SELECT 
    account_id,
    amount,
    tx_type,
    COALESCE(description, 'COBRO INSTITUCIONAL O COMISIÓN - SIN RECEPTOR') AS descripcion_visible
FROM core.transactions
WHERE description IS NULL AND tx_type = 'WITHDRAWAL';