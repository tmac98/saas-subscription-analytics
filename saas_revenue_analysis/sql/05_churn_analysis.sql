-- Churn analysis: logo churn, gross revenue churn, and net revenue retention (NRR)

WITH monthly_status AS (
    SELECT
        month,
        subscription_id,
        mrr_usd,
        churned_this_month
    FROM monthly_activity
),

subs_by_month AS (
    SELECT
        month,
        COUNT(DISTINCT subscription_id) AS active_subscriptions
    FROM monthly_status
    GROUP BY month
),

churned_mrr AS (
    SELECT
        month,
        SUM(mrr_usd) AS mrr_lost
    FROM monthly_status
    WHERE churned_this_month = TRUE
    GROUP BY month
),

mrr_by_month AS (
    SELECT
        month,
        SUM(mrr_usd) AS total_mrr
    FROM monthly_status
    GROUP BY month
),

nrr_calc AS (
    SELECT
        m.month,
        m.total_mrr,
        LAG(m.total_mrr) OVER (ORDER BY m.month) AS prev_mrr
    FROM mrr_by_month m
)

SELECT
    s.month,
    s.active_subscriptions,
    COALESCE(c.mrr_lost, 0) AS churned_mrr,
    
    -- Logo churn % = churned subs / previous month's active subs
    ROUND(
        COALESCE(
            c.mrr_lost * 0 + 
            (
                SELECT COUNT(DISTINCT subscription_id)
                FROM monthly_activity
                WHERE churned_this_month = TRUE
                AND month = s.month
            ), 
        0)
        * 100.0
        /
        LAG(s.active_subscriptions) OVER (ORDER BY s.month), 
    2) AS logo_churn_rate,
    
    -- Gross revenue churn % = churned MRR / previous month's MRR
    ROUND(
        COALESCE(c.mrr_lost, 0) * 100.0
        /
        LAG(m.total_mrr) OVER (ORDER BY s.month),
    2) AS gross_mrr_churn_rate,

    -- NRR = current MRR / previous MRR
    ROUND(
        CASE 
            WHEN n.prev_mrr IS NULL THEN NULL
            ELSE (n.total_mrr / n.prev_mrr) * 100.0
        END,
    2) AS net_revenue_retention

FROM subs_by_month s
LEFT JOIN churned_mrr c USING (month)
LEFT JOIN mrr_by_month m USING (month)
LEFT JOIN nrr_calc n USING (month)
ORDER BY s.month;
