[Clientes] 1 ------------ N [Cuentas]
- cliente_id (PK)             - cuenta_id (PK)
- nombre                      - cliente_id (FK)
- correo                      - moneda
- telefono                    - tipo_cuenta
- fecha_nacimiento            - saldo_actual
- tax_id                      - limite_credito

                   (Cuenta Origen)
[Cuentas] 1 ------------------------- N [Transacciones]
                                          - transaccion_id (PK)
                   (Cuenta Destino)       - from_account (FK -> Cuentas)
[Cuentas] 1 ------------------------- N   - to_account (FK -> Cuentas)
                                          - monto
                                          - tipo_transaccion
                                          - fecha_completada