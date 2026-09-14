-- ==========================================
-- TAREA 01: REQUERIMIENTOS Y RESTRICCIONES
-- ==========================================

-- Identifica las Entidades:
-- 1. clientes
-- 2. cuentas
-- 3. transacciones 

-- Requerimientos Funcionales:
-- 1. Cada cliente necesita poner su nombre completo, correo electrónico único, 
--    número de teléfono, fecha de nacimiento y su número de identificación fiscal (Tax ID), 
--    el cual no puede repetirse.
-- 2. De las cuentas necesitamos registrar el número de cuenta, la moneda (ej. USD, EUR), 
--    el tipo de cuenta (Checking, Savings, Credit), el saldo actual, y un límite de crédito.
-- 3. Debemos poder registrar cada vez que el dinero se mueve de una cuenta origen a una cuenta destino, 
--    guardando el monto, el tipo de transacción (Depósito, Retiro, Transferencia) y la fecha exacta.

-- Restricciones Clave:
-- El número de identificación fiscal (Tax ID) de cada cliente debe ser único y no puede repetirse.

-- ==========================================
-- CÓDIGO DDL POSTGRESQL 16
-- ==========================================

-- Tabla Clientes con restricción UNIQUE en Tax ID
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    fecha_nacimiento DATE NOT NULL,
    tax_id VARCHAR(50) NOT NULL UNIQUE
);