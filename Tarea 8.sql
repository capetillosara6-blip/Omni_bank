-- report_aml_sar_detection.sql

SELECT
    transaction_id,
    amount,
    tx_type,
    tx_timestamp,
    COALESCE(
        description,
        'EXCLUSIÓN OPORTUNAMENTE DETECTADA - SIN MOTIVO DE PAGO'
    ) AS descripcion_monitoreada
FROM core.transactions
WHERE
    (
        amount >= 10000.00
        AND tx_type IN ('TRANSFER', 'WITHDRAWAL')
    )
    OR
    (
        (
            NULLIF(TRIM(description), '') IS NULL
            AND tx_type != 'DEPOSIT'
        )
        OR description ILIKE '%crypto%'
        OR description ILIKE '%offshore%'
        OR description ILIKE '%shell%'
        OR description ILIKE '%casino%'
    )
ORDER BY amount DESC;