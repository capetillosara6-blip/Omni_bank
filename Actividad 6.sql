Actividad 6 -- migration_01_core_evolution.sql

CREATE TYPE core.loan_status_enum AS ENUM (
    'ACTIVE',
    'PAID',
    'DEFAULTED',
    'CANCELLED'
);

BEGIN;

-- Agregar Credit Score a los clientes
ALTER TABLE core.customers
ADD COLUMN credit_score INTEGER;

ALTER TABLE core.customers
ADD CONSTRAINT chk_customers_credit_score_range
CHECK (credit_score BETWEEN 300 AND 850);

-- Agregar IBAN a las cuentas
ALTER TABLE core.accounts
ADD COLUMN iban VARCHAR(34) NULL;

ALTER TABLE core.accounts
ADD CONSTRAINT uq_accounts_iban
UNIQUE (iban);

-- Cambiar status de VARCHAR a ENUM
ALTER TABLE core.loans
ALTER COLUMN status TYPE core.loan_status_enum
USING status::core.loan_status_enum;

COMMIT;