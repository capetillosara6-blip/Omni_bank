Tarea 6 1. Causa del problema

El error ocurrió porque PostgreSQL tuvo que revisar las 75 millones de filas para comprobar el nuevo CHECK. Durante esta operación se obtuvo un bloqueo ACCESS EXCLUSIVE, por lo que las operaciones que necesitaban acceder a core.transactions quedaron esperando y la aplicación dejó de responder.

Solución con NOT VALID

Para evitar el bloqueo prolongado, primero se agrega la restricción sin revisar los datos históricos:

ALTER TABLE core.transactions
ADD CONSTRAINT chk_transactions_description_valid
CHECK (LENGTH(TRIM(description)) >= 5)
NOT VALID;

Después, en otro momento, se valida el historial:

ALTER TABLE core.transactions
VALIDATE CONSTRAINT chk_transactions_description_valid;

Así, la primera etapa protege los nuevos datos sin escanear las 75 millones de filas, y la segunda revisa los datos antiguos con un bloqueo menor.

Conclusión

El problema fue realizar la validación completa directamente en producción. La solución es utilizar el método de dos pasos: NOT VALID y después VALIDATE CONSTRAINT, reduciendo el impacto sobre las operaciones del banco.