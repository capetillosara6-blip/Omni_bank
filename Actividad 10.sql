-- Grano: account_type. balance procede solo de accounts.
SELECT account_type,
       COUNT(*) AS account_count,
       SUM(balance) AS stored_balance_total,
       MIN(balance) AS smallest_stored_balance,
       MAX(balance) AS largest_stored_balance,
       ROUND(AVG(balance),2) AS average_stored_balance
FROM core.accounts
WHERE is_active
GROUP BY account_type
ORDER BY stored_balance_total DESC,account_type;

-- Grano: cliente. transaction_id cuenta eventos reales, no filas externas.
SELECT c.customer_id,c.first_name,c.last_name,c.email,
       COUNT(t.transaction_id) AS recorded_event_count,
       COALESCE(SUM(t.amount),0) AS recorded_gross_volume
FROM core.customers c
LEFT JOIN core.accounts a ON a.customer_id=c.customer_id
LEFT JOIN core.transactions t ON t.account_id=a.account_id
GROUP BY c.customer_id,c.first_name,c.last_name,c.email
HAVING COUNT(t.transaction_id)>=2 OR COALESCE(SUM(t.amount),0)>100
ORDER BY recorded_gross_volume DESC,c.email;

-- Controles independientes: cada medida se obtiene en su tabla de origen.
SELECT COUNT(*) AS active_accounts,SUM(balance) AS stored_balance_total
FROM core.accounts WHERE is_active;
SELECT COUNT(*) AS recorded_events,SUM(amount) AS recorded_gross_volume
FROM core.transactions;