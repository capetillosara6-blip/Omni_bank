SELECT COUNT(*) AS total_accounts,
       COUNT(*) FILTER (WHERE NOT is_active) AS inactive_accounts,
       ROUND(100.0*COUNT(*) FILTER (WHERE NOT is_active)::numeric
             /NULLIF(COUNT(*),0),2) AS inactive_pct
FROM core.accounts;

SELECT CONCAT(UPPER(TRIM(c.first_name)),' ',UPPER(TRIM(c.last_name))) AS customer_name,
       CONCAT('XXXX-',RIGHT(a.account_number,4)) AS masked_account,
       t.transaction_id,t.tx_timestamp,
       t.tx_timestamp + INTERVAL '15 days' AS review_on,
       AGE(TIMESTAMPTZ '2026-10-01 00:00+00',t.tx_timestamp) AS age_at_review
FROM core.transactions t
JOIN core.accounts a ON a.account_id=t.account_id
JOIN core.customers c ON c.customer_id=a.customer_id
WHERE t.tx_timestamp<TIMESTAMPTZ '2026-09-10 00:00+00'
ORDER BY t.tx_timestamp;