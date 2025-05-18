    WITH user_monthly_txn AS (
    SELECT
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS transactions_per_month,
        COUNT(*) AS monthly_txn_count
    FROM
        savings_savingsaccount s
    WHERE
        s.transaction_date IS NOT NULL
    GROUP BY
        s.owner_id, transactions_per_month
),

user_avg_txn AS (
    SELECT
        owner_id,
        AVG(monthly_txn_count) AS avg_transactions_per_month
    FROM
        user_monthly_txn
    GROUP BY
        owner_id
),

user_segment AS (
    SELECT
        owner_id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        user_avg_txn
)

SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM
    user_segment
WHERE
    frequency_category IN ('High Frequency', 'Medium Frequency')
GROUP BY
    frequency_category;
