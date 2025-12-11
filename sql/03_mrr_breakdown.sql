-- Monthly MRR movement breakdown
-- Computes New MRR, Churned MRR, Expansion, Contraction and Reactivation.

WITH base AS (
    SELECT
        subscription_id,
        customer_id,
        plan_id,
        month,
        mrr_usd,
        is_new,
        churned_this_month
    FROM monthly_activity
),

mrr_by_month AS (
    SELECT
        subscription_id,
        month,
        mrr_usd,
        LAG(mrr_usd) OVER (PARTITION BY subscription_id ORDER BY month) AS prev_mrr
    FROM base
),

classifications AS (
    SELECT
        subscription_id,
        month,
        mrr_usd,
        prev_mrr,
        
        CASE 
            WHEN prev_mrr IS NULL AND mrr_usd > 0 THEN mrr_usd
            ELSE 0
        END AS new_mrr,

        CASE 
            WHEN prev_mrr IS NOT NULL AND mrr_usd > prev_mrr THEN mrr_usd - prev_mrr
            ELSE 0
        END AS expansion_mrr,

        CASE 
            WHEN prev_mrr IS NOT NULL AND mrr_usd < prev_mrr AND mrr_usd > 0 THEN prev_mrr - mrr_usd
            ELSE 0
        END AS contraction_mrr,

        CASE 
            WHEN prev_mrr = 0 AND mrr_usd > 0 THEN mrr_usd
            ELSE 0
        END AS reactivation_mrr,

        CASE 
            WHEN mrr_usd = 0 AND prev_mrr > 0 THEN prev_mrr
            ELSE 0
        END AS churned_mrr
    FROM mrr_by_month
),

monthly_totals AS (
    SELECT
        month,
        ROUND(SUM(new_mrr), 2)          AS new_mrr,
        ROUND(SUM(expansion_mrr), 2)    AS expansion_mrr,
        ROUND(SUM(contraction_mrr), 2)  AS contraction_mrr,
        ROUND(SUM(reactivation_mrr), 2) AS reactivation_mrr,
        ROUND(SUM(churned_mrr), 2)      AS churned_mrr
    FROM classifications
    GROUP BY month
)

SELECT
    month,
    new_mrr,
    expansion_mrr,
    contraction_mrr,
    reactivation_mrr,
    churned_mrr,
    (new_mrr + expansion_mrr + reactivation_mrr
       - churned_mrr - contraction_mrr) AS net_new_mrr
FROM monthly_totals
ORDER BY month;
