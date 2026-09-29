[Sucursales] (3NF - Elimina redundancia transitiva de direcciones repetidas en cada venta)
- sucursal_id (PK)      -- Ej: S-CDMX
- direccion             -- Ej: Av. Juárez #100

[Clientes] (3NF - Elimina duplicidad masiva del cliente en cada transacción o cuenta)
- cliente_id (PK/TaxID) -- Ej: TAX-9911 (O preferentemente UUID en práctica real)
- nombre                -- Ej: Roberto Soto
- email                 -- Ej: rob@mail.com
- telefono              -- Ej: 555-9011

[Cuentas] (3NF - Dependencia directa de Cuenta a Cliente y Sucursal de apertura)
- cuenta_numero (PK)    -- Ej: CTA-100
- cliente_id (FK -> Clientes)
- sucursal_id (FK -> Sucursales)
- moneda                -- Ej: USD
- tipo_cuenta           -- Ej: Checking
- saldo_actual          -- Ej: 1300.00

[Transacciones] (3NF - Registro atómico exclusivo del evento financiero)
- transaccion_id (PK)   -- Ej: TX-0001, TX-0002
- cuenta_numero (FK -> Cuentas)
- fecha_tx
- monto_tx