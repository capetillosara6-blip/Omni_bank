SELECT a.account_number,a.account_type,a.balance
FROM core.accounts a
WHERE a.is_active
  AND NOT EXISTS (
    SELECT 1 FROM core.transactions t WHERE t.account_id=a.account_id
  )
ORDER BY a.account_number;

SELECT a.account_number,a.is_active
FROM core.accounts a
WHERE NOT EXISTS (
  SELECT 1 FROM core.transactions t
  WHERE t.account_id=a.account_id AND t.tx_type='DEPOSIT'
)
ORDER BY a.account_number;

WITH valores(x) AS (VALUES (1),(NULL::integer))
SELECT 2 NOT IN (SELECT x FROM valores) AS not_in_with_null,
       NOT EXISTS (SELECT 1 FROM valores WHERE x=2) AS not_exists_result;