WITH movement AS (
 SELECT account_id, COUNT(*) AS tx_count, SUM(amount) AS gross_volume
 FROM core.transactions GROUP BY account_id
), account_metrics AS (
 SELECT a.account_id, a.account_number, a.currency, a.customer_id,
        COALESCE(m.tx_count,0) AS tx_count,
        COALESCE(m.gross_volume,0) AS gross_volume
 FROM core.accounts a LEFT JOIN movement m USING (account_id)
 WHERE a.is_active
)
SELECT c.first_name, c.last_name, am.account_number, am.currency,
       am.tx_count, am.gross_volume,
       CASE WHEN am.tx_count = 0 THEN 'SIN MOVIMIENTOS' ELSE 'CON MOVIMIENTOS' END AS activity_band
FROM account_metrics am JOIN core.customers c USING (customer_id)
ORDER BY am.account_number;
SELECT (SELECT COUNT(*) FROM core.accounts WHERE is_active) AS active_accounts,
       (SELECT COALESCE(SUM(amount),0) FROM core.transactions) AS direct_gross_volume;