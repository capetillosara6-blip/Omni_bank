WITH sample(x) AS (VALUES (NULL::numeric),(10000::numeric),(0::numeric),(0::numeric))
SELECT ROUND(AVG(x),2) AS ignores_null,
       ROUND(AVG(COALESCE(x,0)),2) AS treats_null_as_zero
FROM sample;

SELECT c.email,a.account_number,a.balance AS stored_balance,
       COUNT(t.transaction_id) AS movement_count,
       COALESCE(SUM(t.amount),0) AS recorded_gross_volume
FROM core.customers c JOIN core.accounts a USING (customer_id)
LEFT JOIN core.transactions t USING (account_id)
WHERE a.account_type='CREDIT' AND a.is_active
GROUP BY c.customer_id,c.email,a.account_id,a.account_number,a.balance
HAVING COALESCE(SUM(t.amount),0)>=300 OR COUNT(t.transaction_id)=0
ORDER BY recorded_gross_volume DESC;