-- Savings plans with no inflow in the last year
SELECT
    s.plan_id,
    s.owner_id,
    'Savings' AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM
    savings_savingsaccount s
JOIN plans_plan p ON s.plan_id = p.id
WHERE
    p.is_regular_savings = 1
    AND s.confirmed_amount > 0
GROUP BY
    s.plan_id, s.owner_id
HAVING
    MAX(s.transaction_date) < CURDATE() - INTERVAL 365 DAY

UNION

-- Investment plans with no inflow in the last year
SELECT
    s.plan_id,
    s.owner_id,
    'Investment' AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM
    savings_savingsaccount s
JOIN plans_plan p ON s.plan_id = p.id
WHERE
    p.is_a_fund = 1
    AND s.confirmed_amount > 0
GROUP BY
    s.plan_id, s.owner_id
HAVING
    MAX(s.transaction_date) < CURDATE() - INTERVAL 365 DAY;
