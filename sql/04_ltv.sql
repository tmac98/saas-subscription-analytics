-- Cohort-based LTV calculation
-- Computes cumulative revenue per subscription for each cohort-month.

WITH monthly_revenue AS (
    SELECT
        subscription_id,
        cohort_month,
        month AS activity_month,
        mrr_usd
    FROM monthly_activity
),

cohort_age AS (
    SELECT
        subscription_id,
        cohort_month,
        activity_month,
        mrr_usd,
        DATE_DIFF(activity_month, cohort_month, MONTH) AS months_since_cohort
    FROM monthly_revenue
),

subscription_ltv AS (
    SELECT
        subscription_id,
        cohort_month,
        months_since_cohort,
        SUM(mrr_usd) OVER (
            PARTITION BY subscription_id
            ORDER BY months_since_cohort
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue
    FROM cohort_age
),

cohort_ltv AS (
    SELECT
        cohort_month,
        months_since_cohort,
        ROUND(AVG(cumulative_revenue), 2) AS avg_ltv
    FROM subscription_ltv
    GROUP BY cohort_month, months_since_cohort
)

SELECT
    cohort_month,
    months_since_cohort,
    avg_ltv
FROM cohort_ltv
ORDER BY cohort_month, months_since_cohort;
