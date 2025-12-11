# Project Structure

Below is a description of each folder and file in the project.

---

## Root Files

### `README.md`
Project overview and objectives.

### `project_structure.md`
This document.

### `requirements.txt`
Python dependencies.

---

## data/

Stores all generated datasets.

### `data/raw/`
Synthetic base tables:
- customers
- subscription plans
- subscriptions

### `data/processed/`
Cleaned and enriched datasets used for analysis, modelling, and dashboards.

---

## sql/

SQL files used for revenue, retention, and cohort analysis:

- `01_create_cohorts.sql`
- `02_retention_by_month.sql`
- `03_mrr_breakdown.sql`
- `04_ltv.sql`
- `05_churn_analysis.sql`

---

## notebooks/

Python notebooks for data preparation and analysis:

- `01_data_cleaning.ipynb`
- `02_retention_analysis.ipynb`
- `03_mrr_forecasting.ipynb`
- `04_pricing_segmentation.ipynb`
- `05_final_insights.ipynb`

---

## dashboard/

Business intelligence assets generated from Tableau.

### `dashboard/pdfs/`
High resolution exports of the final dashboards:
- **SAAS Revenue Overview.pdf**  
- **Retention & Churn Health.pdf**

---

## pdf/

### `SaaS_Subscription_Analytics_Report.pdf`
Written summary of main findings.

