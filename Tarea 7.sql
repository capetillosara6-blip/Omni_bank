1. Crítica y Refutación al Anti-Patrón "Read-Before-Write"
El algoritmo propuesto por el desarrollador junior con base en consultas condicionales previas incurre en dos de los mayores antipatrones del desarrollo de software empresarial sobre bases de datos de alto tráfico:

Colapso de Latencia por Doble Viaje Continuo (Round-Trip Amplified latency): Enviar 1 millón de consultas previas por la red exclusivamente para averiguar ("leer") si el usuario radicaba antes en disco, solo para después procesar y disparar un millón de escrituras condicionales por separado, infligirá al sistema 2 millones de idas y vueltas al motor computacional por sobrecarga en sockets e hilos del sistema.
La Trinchera de Vulnerabilidad: Condiciones de Carrera (Race Conditions): Una consulta de lectura (SELECT) anterior y desconectada del paso de escritura no bloquea la fila transaccional del disco (salvo que impliques bloqueos intensivos como SELECT FOR UPDATE). Si dos servidores obreros paralelos procesan o intentan cargar concurrente o accidentalmente la misma persona al mismo instante:
Obrero A lanza su SELECT, no detecta nada y decide ir a la rama de crear de cero con INSERT.
Exactamente un milisegundo después (antes de que Obrero A haya completado de guardar en disco), Obrero B dispara su SELECT; tampoco detecta nada aún en el catálogo de clientes, ¡y consecuentemente marcha decidido y engañado hacia su propia rama de crear con INSERT!
Ambos obreros chocan irremediable al llegar de frente y en paralelo con sus dos comandos al motor; el segundo termina abortando ruidosamente en rojo fulminante su transacción con error de duplicidad relacional (duplicate key value violates unique constraint), rompiendo y suspendiendo el pipeline computacional bancario a media madrugada.
2. Solución Profesional Definida e Idempotente (UPSERT con EXCLUDED y RETURNING)
El siguiente mandato atómico resuelve el 100% de la carga del pipeline KYC en un solo viaje computado en el servidor con resiliencia transaccional absoluta y cero riesgo de condición de carrera:

-- Guion Oficial para Sincronización KYC en OmniBank:
INSERT INTO core.customers (first_name, last_name, email, phone_number, tax_id)
VALUES 
    ('Humberto', 'López', 'hlopez@email.com', '+52-55-4433-2211', 'TAX-990011')
ON CONFLICT (email) 
DO UPDATE SET 
    first_name   = EXCLUDED.first_name,
    last_name    = EXCLUDED.last_name,
    phone_number = EXCLUDED.phone_number,
    -- (Es vital dejar intacta y no tocar deliberadamente nuestra fecha de alta created_at ni su UUID)
    is_active    = true
RETURNING customer_id, email, is_active;

Análisis Operativo de la Sentencia:

Cuando el ciudadano ingresa por vez primera (30% del volumen), el motor evalúa milimétricamente el INSERT convencional por entero y nos escupe triunfal en milisegundos las celdas generadas vía RETURNING.
Cuando ese titular bancario ya existía consolidadamente en producción (70% de la masa), la compuerta nativa de PostgreSQL intercepta limpiamente la colisión sobre el índice del email y deriva al instante la ejecución hacia la cláusula DO UPDATE. En lugar de fracasar con un error por duplicado o reescribir torpemente identificadores fijos históricos del pasado, apelamos con destreza industrial a la variable y tabla efímera EXCLUDED, la cual envuelve mágicamente las celdas renovadas que arribaron en nuestro bloque VALUES, actualizando milimétricamente el nombre y el número telefónico sin romper ni en lo absoluto alterar la integridad de las llaves foráneas o el registro secular con el que el cliente se dio de alta años atrás.
