-- Cohort table: one row per cohort_month
-- Defines the size of each cohort and provides the foundation for retention analysis.

WITH first_activity AS (
    SELECT
        subscription_id,
        customer_id,
        plan_id,
        cohort_month,
        MIN(month) AS first_active_month
    FROM monthly_activity
    GROUP BY 1, 2, 3, 4
),

cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT subscription_id) AS cohort_subscriptions
    FROM first_activity
    GROUP BY cohort_month
)

SELECT
    cohort_month,
    cohort_subscriptions
FROM cohort_sizes
ORDER BY cohort_month;
