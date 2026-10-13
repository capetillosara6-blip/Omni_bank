Problema

El método SELECT + INSERT/UPDATE hace varias consultas por cada registro, aumentando el tiempo de procesamiento. Además, con varios servidores pueden ocurrir condiciones de carrera, provocando errores por registros duplicados.

Solución

Se utiliza UPSERT, que permite insertar o actualizar en una sola operación:

INSERT INTO core.customers
(customer_id, first_name, last_name, email, phone_number)
VALUES
('11111111-1111-1111-1111-111111111111',
 'John', 'Doe', 'john.doe@email.com', '555-0100')
ON CONFLICT (email)
DO UPDATE SET
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    phone_number = EXCLUDED.phone_number
RETURNING customer_id, email;

EXCLUDED contiene los datos nuevos. Así se actualizan solo los datos indicados y se conservan el customer_id y created_at originales.