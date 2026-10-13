-- 1. Compilación del nuevo Tipo Enumerado en PostgreSQL para el ciclo de vida crediticio
CREATE TYPE core.loan_status_enum AS ENUM ('ACTIVE', 'PAID', 'DEFAULTED', 'CANCELLED');

-- 2. Inicio innegociable de transaccionalidad DDL en PostgreSQL
BEGIN;

-- Transformación 1: Añadir métrica de puntuación crediticia a los titulares bancarios con su constraint en duro
ALTER TABLE core.customers 
    ADD COLUMN credit_score INTEGER NULL;

ALTER TABLE core.customers 
    ADD CONSTRAINT chk_customers_credit_score_range 
    CHECK (credit_score BETWEEN 300 AND 850);

-- Transformación 2: Estandarización europea de identificación de cuentas bancarias y unicidad
ALTER TABLE core.accounts 
    ADD COLUMN iban VARCHAR(34) NULL;

ALTER TABLE core.accounts 
    ADD CONSTRAINT uq_accounts_iban UNIQUE (iban);

-- Transformación 3: Casteo estructural de columna de texto libre de préstamos a nuestro riguroso Enum catalogado
ALTER TABLE core.loans 
    ALTER COLUMN status DROP DEFAULT,
    ALTER COLUMN status TYPE core.loan_status_enum USING status::core.loan_status_enum,
    ALTER COLUMN status SET DEFAULT 'ACTIVE'::core.loan_status_enum;

-- Si ningún solo paso presentó divergencias en terminal o fallos operantes de conversión sintáctica:
COMMIT;