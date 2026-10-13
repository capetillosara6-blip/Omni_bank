Actividad 7 

-- 03_initial_data.sql

BEGIN;

-- 1. Clientes
INSERT INTO core.customers
(customer_id, first_name, last_name, email, phone, tax_id, birth_date)
VALUES
('11111111-1111-1111-1111-111111111111', 'John', 'Doe', 'john.doe@email.com', '555-0100', 'TAX-100', '1985-04-12'),
('22222222-2222-2222-2222-222222222222', 'Jane', 'Smith', 'jane.smith@email.com', '555-0200', 'TAX-200', '1990-08-25'),
('33333333-3333-3333-3333-333333333333', 'Alice', 'Johnson', 'alice.j@email.com', '555-0300', 'TAX-300', '1978-11-05')
ON CONFLICT (email) DO NOTHING;


-- 2. Cuentas
INSERT INTO core.accounts
(account_id, customer_id, account_number, account_type, balance, credit_limit)
VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 '11111111-1111-1111-1111-111111111111',
 'ACCT-1001', 'CHECKING', 5000.00, 0),

('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
 '22222222-2222-2222-2222-222222222222',
 'ACCT-2001', 'SAVINGS', 15000.00, 0),

('cccccccc-cccc-cccc-cccc-cccccccccccc',
 '33333333-3333-3333-3333-333333333333',
 'ACCT-3001', 'CREDIT', 0.00, 10000.00)
ON CONFLICT (account_number) DO NOTHING;


-- 3. Transacciones
INSERT INTO core.transactions
(transaction_id, from_account_id, to_account_id, amount, currency_type, transaction_type, status)
VALUES
('44444444-4444-4444-4444-444444444444',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
 150.00, 'USD', 'TRANSFER', 'COMPLETED'),

('55555555-5555-5555-5555-555555555555',
 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
 'cccccccc-cccc-cccc-cccc-cccccccccccc',
 300.00, 'USD', 'TRANSFER', 'COMPLETED'),

('66666666-6666-6666-6666-666666666666',
 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 NULL,
 50.00, 'USD', 'FEE', 'COMPLETED');


-- 4. Descontar comisión de John
UPDATE core.accounts
SET balance = balance - 50.00
WHERE account_number = 'ACCT-1001'
RETURNING account_number, balance;


COMMIT;