# E-Commerce Business Analysis with SQL

A business-focused SQL case study analyzing an e-commerce dataset using PostgreSQL in Metabase. Rather than simply answering SQL questions, this project investigates key business areas including revenue trends, customer retention, conversion funnel performance, product and category health, payment reliability, delivery operations, customer lifetime value, repeat purchase behavior, and marketing attribution.

The project consists of **10 SQL analyses**, each designed to answer a real business question and provide actionable recommendations for business stakeholders. Alongside the SQL queries, the findings are summarized in a business case study written as a memo to the company's founder.

---

## Project Objectives

This project aims to:

- Analyze the overall health of the business using SQL.
- Identify growth opportunities through customer and marketing analytics.
- Measure operational efficiency across payments and logistics.
- Translate SQL outputs into business recommendations.
- Demonstrate SQL skills together with analytical storytelling.

---

## Business Questions Answered

The project includes the following analyses:

| Query | Business Question |
|--------|-------------------|
| Query 01 | Daily Business Summary |
| Query 02 | Monthly Cohort Retention Analysis |
| Query 03 | Funnel Conversion Analysis |
| Query 04 | Product Revenue & Returns Analysis |
| Query 05 | Category Sales & Returns Analysis |
| Query 06 | Payment Failure Analysis |
| Query 07 | Delivery SLA Performance Analysis |
| Query 08 | Customer Lifetime Value (LTV) Analysis |
| Query 09 | Repeat Purchase Analysis |
| Query 10 | First-Touch vs Last-Touch Attribution |

---

## Skills Demonstrated

- SQL
- PostgreSQL
- Metabase
- Common Table Expressions (CTEs)
- Window Functions (`LAG`, `LEAD`, `ROW_NUMBER`)
- Aggregations
- Filtered Aggregates (`FILTER`)
- Cohort Analysis
- Funnel Analysis
- Marketing Attribution
- Customer Segmentation
- Customer Lifetime Value (LTV)
- Business Intelligence
- Data Storytelling

---

## Business Case Study

A complete business case study summarizing the findings is available on Notion.

**Notion Case Study**

> **What 10 SQL Queries Told Me About This Business**

**Link:**  
https://your-notion-link

---

## LinkedIn

You can connect with me here:

https://linkedin.com/in/your-linkedin-profile

---

## Repository Structure

```
Ecommerce-SQL-Case-Study/
│
├── sql/
│   ├── Query01_Daily_Business_Summary.sql
│   ├── Query02_Monthly_Cohort_Retention.sql
│   ├── Query03_Funnel_Conversion.sql
│   ├── Query04_Product_Revenue_Returns.sql
│   ├── Query05_Category_Sales_Returns.sql
│   ├── Query06_Payment_Failure_Analysis.sql
│   ├── Query07_Delivery_SLA_Analysis.sql
│   ├── Query08_Customer_LTV.sql
│   ├── Query09_Repeat_Purchase.sql
│   └── Query10_Marketing_Attribution.sql
│
├── screenshots/
│
└── README.md
```

---

## How to Run

This project was developed using the **internal Metabase server** connected to a PostgreSQL database.

To reproduce the analysis:

1. Open the internal Metabase server.
2. Connect to the PostgreSQL database.
3. Select the **`ecom`** schema.
4. Open any SQL file from the `sql/` folder.
5. Execute the query inside Metabase.
6. Compare the output with the screenshots and business insights documented in the Notion case study.

---

## Methodology

The analysis was performed using SQL against the **`ecom` PostgreSQL schema** in Metabase.

The project consists of **10 business-focused SQL analyses** covering:

- Daily business performance
- Customer cohort retention
- Conversion funnel analysis
- Product revenue and returns
- Category sales and returns
- Payment failures
- Delivery SLA performance
- Customer lifetime value (LTV)
- Repeat purchase behaviour
- Marketing attribution

To ensure the insights reflected **recent business performance**, most analyses were restricted to the **latest 90 days of available data**, using the maximum transaction date in the dataset as the reference point.

Additional assumptions include:

- Cancelled orders were excluded from revenue, retention, repeat purchase, LTV, and attribution analyses.
- Delivery SLA metrics include only successfully delivered shipments.
- Cohort analysis applies right-censoring so incomplete cohorts are not treated as having zero retention.
- Window functions, CTEs, filtered aggregates, and percentile calculations were used throughout the project.

---

## Key Business Findings

- Organic Search and Paid Marketing together contribute approximately **75% of attributed revenue**.
- The purchase funnel performs consistently across acquisition channels, indicating traffic growth is a larger opportunity than checkout optimization.
- Customer retention declines significantly after the first month, highlighting the need for stronger post-purchase engagement.
- Payment failures—particularly UPI gateway timeouts—represent avoidable revenue loss.
- Delivery performance varies considerably across shipping carriers despite generally low product return rates.

---

## Reflection

Working on this project helped me move beyond writing SQL queries and think more like a business analyst. I learned how to translate transactional data into actionable insights and communicate findings in a way that business stakeholders can understand. It also strengthened my understanding of window functions, cohort analysis, funnel analytics, and marketing attribution. If I were extending this project, I would integrate marketing spend, customer demographics, and inventory data to calculate ROAS, CAC, and inventory efficiency. I would also build an interactive Power BI or Metabase dashboard to monitor these KPIs over time instead of relying solely on static SQL analyses.

---

## Author

**Tabish Shamim**

- LinkedIn: https://linkedin.com/in/your-linkedin-profile
