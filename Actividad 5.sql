CREATE SCHEMA IF NOT EXISTS core;

CREATE DOMAIN saldo AS NUMERO (15,2) CHECK (VALUE > = 0);

CREATE DOMAIN texto_obligatorio AS VARCHAR (100) CHECK (VALUE <> AND LENGTH (TRIM(VALUE))>0)

CREATE TABLE customers core.customers
customers_id UUID DEFAULT gen_random_uuid(),
nombre_completo VARCHAR (100) NOT NULL,
email VARCHAR (150) NOT NULL,
fecha_registro TIMESTAMPTZ DEFAULT CURRENT_TIEMTAMP NOT NULL,
 IS_ACTIVE BOOLEAN DEFAULT TRUE NOT NULL,

CONSTRAINT pk_clientes PRIMARY KEY (customers),
CONSTRAINT uq_clientes_email UNIQUE (email);

CREATE TABLE accounts core.accounts 
accounts_id UUID DEFAULT gen_random_uuid(), 
customers_id NOT NULL, 
saldo AS NUMERIC (15,2)CHECK (VALUE > = 0),
tipo_moneda core.tipo_moneda NOT NULL

CONSTRAINT pk_accounts PRIMARY KEY (accounts_id),
CONSTRAINT fk_cliente_id FOREIGN KEY (customers_id);

CREATE TABLE loans core.loans
loans_id 
customers_id NOT NULL 
AMOUNT NUMERIC (15,2) CHECK (AMOUNT > 0),
INTEREST_RATE NUMERIC (5,4),
STATUS VARCHAR (20)

CONSTRAINT customers_id FOREIGN KEY 
REFERENCES core.customers (customers_id);

CREATE TABLE trasactions core.trasactions
trasactions_id UUID 
accounts_id UUID NOT NULL,
AMOUNT NUMERIC (15,2) CHECK (AMOUNT > 0 ), 
tipo_trasactions core.tipo_trasactions NOT NULL,
transaction_date TIMESTAMPTZ NOT NULL

CONSTRAINT accounts_id FOREIGN KEY



