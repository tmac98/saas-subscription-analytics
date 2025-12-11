# SaaS Revenue Analysis

This project examines the revenue performance, customer retention, pricing behaviour, and churn dynamics of a fictional subscription-based software company. The analysis focuses on understanding the stability of recurring revenue, identifying risks to growth, and highlighting commercial opportunities across customer segments and pricing tiers.

The company operates on a monthly and annual subscription model with three plan levels. Customers upgrade, downgrade, renew, and churn in ways that reflect realistic subscription behaviour.

The outputs of this project include:

- Cohort retention tables and visualisations  
- MRR and ARR breakdowns  
- Gross and net churn metrics  
- Lifetime value (LTV) analysis  
- Pricing and plan performance insights  
- Revenue forecasting

All data used in this project is synthetic but constructed to reflect patterns commonly observed in SaaS businesses.

---

## 📦 Workflow Overview

This project follows a simple analytical workflow:

1. Synthetic subscription and customer data is generated in  
   `notebooks/01_data_cleaning.ipynb`  
   and written to `data/raw/` and `data/processed/`.

2. SQL scripts in the `sql/` directory are used to create cohorts, compute retention,
   calculate MRR components, model churn, and estimate LTV.

3. The analysis notebooks (`notebooks/`) contain exploratory work, visualisations,
   pricing segmentation, and forecasting based on the processed tables.

4. The dashboards (in `dashboard/`) provide a view of
   subscription performance, revenue trends, and cohort behaviour.

5. Key findings are summarised in the insights report (`pdf/insights_report.pdf`).

---

## 📂 Project Contents

- **data/** — Raw and processed synthetic datasets  
- **sql/** — Cohort creation, retention, MRR, churn, and LTV logic  
- **notebooks/** — Cleaning, analysis, segmentation, forecasting, and insights  
- **dashboard/** — Revenue & retention dashboard + screenshots  
- **pdf/** — Final insights report  

---

## 📝 Notes

- All numbers are fictional and for analytical demonstration only.  
- The focus is on replicating the type of revenue and customer analytics used by SaaS companies.  
- No external setup is required; outputs are included directly in the repository.


