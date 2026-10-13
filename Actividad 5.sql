1. Script SQL de Creación Relacional (DDL Core)
-- 1. Asegurar la creación de nuestro esquema relacional centralizado
CREATE SCHEMA IF NOT EXISTS core;

-- 2. Declarar Entidad Raíz Madre: customers
CREATE TABLE core.customers (
    customer_id UUID DEFAULT gen_random_uuid(),
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(30),
    tax_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT true NOT NULL,
    
    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_email UNIQUE (email),
    CONSTRAINT uq_customers_tax_id UNIQUE (tax_id)
);

-- 3. Declarar Entidad Hija Financiera de Cuentas: accounts
CREATE TABLE core.accounts (
    account_id UUID DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    account_number VARCHAR(30) NOT NULL,
    currency core.tipo_moneda DEFAULT 'USD' NOT NULL,
    account_type core.tipo_cuenta DEFAULT 'CHECKING' NOT NULL,
    balance NUMERIC(15, 2) DEFAULT 0.00 NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT true NOT NULL,
    
    CONSTRAINT pk_accounts PRIMARY KEY (account_id),
    CONSTRAINT uq_accounts_number UNIQUE (account_number),
    CONSTRAINT chk_accounts_balance_no_negativo CHECK (balance >= 0.00),
    CONSTRAINT fk_accounts_customer FOREIGN KEY (customer_id)
        REFERENCES core.customers(customer_id) ON DELETE RESTRICT
);

-- 4. Declarar Entidad Hija de Crédito Bancario: loans
CREATE TABLE core.loans (
    loan_id UUID DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    loan_number VARCHAR(30) NOT NULL,
    principal_amount NUMERIC(15, 2) NOT NULL,
    interest_rate NUMERIC(6, 4) NOT NULL, -- Ej: 0.0850 para un 8.5%
    status VARCHAR(20) DEFAULT 'ACTIVE' NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    CONSTRAINT pk_loans PRIMARY KEY (loan_id),
    CONSTRAINT uq_loans_number UNIQUE (loan_number),
    CONSTRAINT chk_loans_principal CHECK (principal_amount > 0.00),
    CONSTRAINT chk_loans_rate CHECK (interest_rate >= 0.00),
    CONSTRAINT fk_loans_customer FOREIGN KEY (customer_id)
        REFERENCES core.customers(customer_id) ON DELETE RESTRICT
);

-- 5. Declarar Entidad Transaccional Inmutable: transactions
CREATE TABLE core.transactions (
    transaction_id UUID DEFAULT gen_random_uuid(),
    account_id UUID NOT NULL,
    tx_type core.tipo_transaccion NOT NULL,
    amount NUMERIC(15, 2) NOT NULL,
    tx_timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    description VARCHAR(250),
    
    CONSTRAINT pk_transactions PRIMARY KEY (transaction_id),
    CONSTRAINT chk_transactions_amount CHECK (amount > 0.00),
    CONSTRAINT fk_transactions_account FOREIGN KEY (account_id)
        REFERENCES core.accounts(account_id) ON DELETE RESTRICT
);