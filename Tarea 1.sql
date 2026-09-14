Identifica la regla de consistencia matemática: ¿Qué regla sobre el saldo (balance) solicita el CTO para proteger las cuentas? la base de datos no debe de permitir que las cuentas tengan un saldo negativo 

Identifica la regla de auditoría (Soft Delete): ¿Cómo debe la base de datos manejar la eliminación de clientes? La base de datos no debe permitir eliminar clientes, cuando un cliente cierre su cuenta se debe marcar como "inactivo"

Identifica la regla de rastreo de tiempo (Timestamps): ¿Qué información temporal es obligatoria en las cuentas cada vez que sufren un cambio? la base de datos debe registrar la fecha y hora exactas de la ultima actualizacion de cada cuenta