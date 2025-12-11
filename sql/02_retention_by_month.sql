-- Retention by month for each cohort
-- Calculates active subscriptions per cohort-month and computes retention percentages.

WITH base AS (
    SELECT
        cohort_month,
        month AS activity_month,
        subscription_id
    FROM monthly_activity
    WHERE is_active = TRUE
),

cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT subscription_id) AS cohort_size
    FROM monthly_activity
    WHERE is_new = TRUE
    GROUP BY cohort_month
),

cohort_activity AS (
    SELECT
        b.cohort_month,
        b.activity_month,
        COUNT(DISTINCT b.subscription_id) AS active_subscriptions
    FROM base b
    GROUP BY 1, 2
),

cohort_age AS (
    SELECT
        c.cohort_month,
        c.activity_month,
        c.active_subscriptions,
        DATE_DIFF(c.activity_month, c.cohort_month, MONTH) AS months_since_cohort
    FROM cohort_activity c
)

SELECT
    ca.cohort_month,
    ca.months_since_cohort,
    ca.active_subscriptions,
    cs.cohort_size,
    ROUND(ca.active_subscriptions * 100.0 / cs.cohort_size, 2) AS retention_rate
FROM cohort_age ca
JOIN cohort_sizes cs USING (cohort_month)
ORDER BY cohort_month, months_since_cohort;
