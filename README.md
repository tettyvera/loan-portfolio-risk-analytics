# Loan Portfolio Performance & Risk Analytics

**An End-to-End Business Intelligence & Credit Risk Analytics Project**

**Project Status:** Completed — Analysis & Dashboard Development  
**Tools:** SQL (DuckDB), Power BI, DAX, Python (Google Colab), Excel/CSV, GitHub  
**Industry:** Financial Technology (Digital Lending)  
**Data:** Synthetic Lending Dataset  
**Reporting Snapshot:** August 31, 2026

---

## 1. Project Overview

This project presents an end-to-end analysis of loan portfolio performance and credit risk in a simulated digital lending company, **LendFlow**.

The analysis focuses on evaluating loan disbursement trends, outstanding principal balances, repayment performance, delinquency exposure, and portfolio risk distribution across lending partners and borrower segments.

Using SQL for data exploration, transformation, and validation, and Power BI for dashboard development, this project demonstrates how financial and operational data can be transformed into actionable business insights.

The final deliverables include two interactive Power BI dashboards:

1. **Executive Overview** — Monitoring overall loan portfolio performance and lending activity.
2. **Credit Risk Analysis** — Identifying delinquency patterns and risk concentrations across lenders, borrower segments, and geographic regions.

## 2. Business Problem

Digital lending companies need accurate and timely portfolio information to monitor lending activities, evaluate repayment performance, and manage credit risk.

As loan portfolios grow, financial and risk management teams must understand not only how much has been disbursed, but also how much remains outstanding, which loans are overdue, and where potential credit risks are concentrated.

In this simulated business scenario, LendFlow's management requires a centralized analytical dashboard to support portfolio monitoring and risk assessment.

**Key Business Questions:**

1. How has loan disbursement changed over time?
2. How much principal remains outstanding?
3. What proportion of the outstanding portfolio is delinquent?
4. Which lending partners have the highest credit risk exposure?
5. How does delinquency vary across borrower risk segments?
6. Which geographic regions contribute the most to outstanding and overdue balances?

## 3. Project Objectives

- Analyze historical and monthly loan disbursement performance.
- Calculate outstanding principal and overdue principal balances.
- Evaluate delinquency using Days Past Due (DPD) and Portfolio at Risk (PAR) metrics.
- Compare loan portfolio performance across lending partners.
- Identify credit risk concentrations by borrower segment and province.
- Develop interactive Power BI dashboards for portfolio monitoring.
- Translate analytical findings into potential business recommendations.

## 4. Tools & Technologies

| Tool | Purpose |
|---|---|
| SQL (DuckDB) | Data exploration, joins, aggregation, and portfolio calculations |
| Google Colab | Executing SQL workflows and preparing analytical datasets |
| Power BI | Interactive dashboard development and reporting |
| DAX | Dynamic KPI calculations and financial metrics |
| Excel / CSV | Dataset storage, inspection, and validation |
| GitHub | Version control, documentation, and portfolio presentation |

## 5. Dataset Description

This project uses a fully synthetic lending dataset designed to simulate the structure of a digital lending portfolio.

The dataset contains historical loan disbursements, borrower information, lending partners, repayment schedules, and payment transactions.

### Dataset Summary

| Dataset | Records | Description |
|---|---:|---|
| borrowers.csv | 1,500 | Borrower profiles and risk segmentation |
| lenders.csv | 4 | Lending partner information |
| loans.csv | 2,000 | Loan disbursement and principal information |
| installments.csv | 19,458 | Scheduled installment obligations |
| repayments.csv | 13,641 | Actual repayment transactions |

### Data Model

The dataset follows a relational structure:

- One borrower can have multiple loans.
- Each loan belongs to one lending partner.
- Each loan can have multiple scheduled installments.
- Each installment can have multiple repayment transactions.

The tables are connected through identifiers such as `borrower_id`, `lender_id`, `loan_id`, and `installment_id`.

**Data Privacy Notice:** All borrowers, lending partners, transactions, and financial figures are fictional. No confidential company information or real customer data is included.

## 6. Data Preparation & SQL Analysis

The SQL workflow consists of four main stages.

### 6.1 Data Exploration

Initial exploratory analysis was conducted to understand dataset structures, relationships, and lending activity.

Key activities included:

- Reviewing data structures and column types.
- Counting loans, borrowers, lenders, installments, and repayments.
- Analyzing disbursement trends.
- Examining loan distribution across lending partners.

### 6.2 Data Quality Validation

Data validation checks were performed to assess analytical consistency.

These included:

- Checking unique identifiers and duplicate records.
- Validating relationships across tables.
- Reviewing missing values and inconsistent records.
- Verifying principal amounts against installment schedules.
- Reconciling disbursed principal, principal repayments, and outstanding balances.

### 6.3 Loan-Level Financial Calculations

Repayment transactions were aggregated at the installment level before calculating loan-level financial metrics.

This approach helps prevent double-counting when joining loan information with multiple repayment transactions.

The analysis calculates financial positions as of **August 31, 2026**, including payments received up to that date.

### 6.4 Delinquency Analysis

Delinquency was evaluated using Days Past Due (DPD), based on the oldest unpaid overdue installment for each loan.

Loans were classified into the following categories:

- Current
- 1–30 DPD
- 31–60 DPD
- 61–89 DPD
- 90+ DPD
- Paid Off

A consolidated loan-level snapshot was created to support Power BI reporting.

## 7. Key Performance Indicators

| KPI | Definition |
|---|---|
| Total Disbursement | Total principal amount disbursed through the reporting snapshot |
| Outstanding Principal | Remaining unpaid principal balance |
| Overdue Principal | Unpaid scheduled principal that has passed its due date |
| Days Past Due (DPD) | Days elapsed since the oldest unpaid overdue installment |
| PAR >30 | Outstanding principal of loans with DPD greater than 30, divided by total outstanding principal |
| PAR 90+ | Outstanding principal of loans with DPD of at least 90, divided by total outstanding principal |

**Important:** PAR measures the outstanding exposure associated with delinquent loans, rather than only the overdue installment amount.

All snapshot-based metrics use August 31, 2026, as the reporting date.

## 8. Power BI Dashboards

Two interactive dashboards were developed to communicate portfolio performance and credit risk insights.

### Dashboard 1 — Executive Overview

![Executive Overview Dashboard](images/executive_overview.png)

**Purpose:** Provide management with a high-level view of lending activity and portfolio health.

**Key Visualizations:**

- Total Disbursement
- Outstanding Principal
- Loans with Outstanding Balances
- PAR >30
- Loan Disbursement Trend
- Outstanding Principal by DPD Bucket
- PAR >30 by Lender
- Disbursement vs Outstanding by Lender
- Portfolio Risk Composition by Lender

Interactive slicers allow users to explore performance by lending partner and borrower risk segment.

### Dashboard 2 — Credit Risk Analysis

![Credit Risk Analysis Dashboard](images/credit_risk_analysis.png)

**Purpose:** Identify delinquency patterns and credit risk concentrations across the loan portfolio.

**Key Visualizations:**

- Outstanding Principal
- Overdue Principal
- PAR >30 and PAR 90+
- Credit Risk Heatmap by Lender and Risk Segment
- PAR >30 by Borrower Risk Segment
- PAR 90+ by Lender
- Outstanding Principal by Province
- Top Provinces by Overdue Principal

The dashboard supports comparisons between portfolio exposure and delinquency severity across lending partners, borrower segments, and regions.

## 9. Key Findings

The following findings were derived from the synthetic loan portfolio as of August 31, 2026.

### Finding 1 — Elevated Portfolio Delinquency

The loan portfolio recorded approximately **IDR 9.59 billion in outstanding principal**, with **PAR >30 reaching 59.98%**.

This indicates that a substantial proportion of outstanding principal is associated with loans more than 30 days past due.

Additionally, PAR 90+ reached **48.89%**, indicating significant severe delinquency exposure within the simulated portfolio.

### Finding 2 — Harbor Finance Has the Highest Delinquency Exposure

Among the four lending partners, Harbor Finance recorded:

- **PAR >30: 68.50%**
- **PAR 90+: 57.95%**

These were the highest delinquency ratios among the lending partners analyzed, indicating a greater proportion of delinquent outstanding exposure.

### Finding 3 — Higher Delinquency Among High-Risk Borrowers

PAR >30 differed significantly across borrower risk segments:

| Risk Segment | PAR >30 |
|---|---:|
| High Risk | 85.25% |
| Medium Risk | 66.29% |
| Low Risk | 43.54% |

The High Risk segment showed the highest delinquency exposure, suggesting a strong association between the synthetic risk classifications and observed repayment performance.

### Finding 4 — Geographic Concentration of Portfolio Exposure

DKI Jakarta accounted for approximately **IDR 2.05 billion in outstanding principal**, making it the largest geographic contributor to the outstanding portfolio.

The region also recorded approximately **IDR 0.94 billion in overdue principal**.

These findings demonstrate the importance of evaluating both geographic portfolio concentration and repayment performance.

## 10. Business Recommendations

Based on the simulated findings, the following actions could be considered by lending, risk, and operations teams.

**1. Strengthen Delinquency Monitoring**

Prioritize regular monitoring of loans entering the 30+ and 90+ DPD categories, with additional investigation into repayment deterioration and collections performance.

**2. Investigate Lender-Level Portfolio Differences**

Review Harbor Finance's delinquency exposure alongside loan vintage, borrower composition, loan tenor, and outstanding balances to better understand differences in portfolio quality.

**3. Apply Risk-Based Portfolio Monitoring**

Evaluate borrower segments with elevated delinquency rates and monitor repayment performance across risk categories.

**4. Monitor Geographic Risk Concentration**

Combine geographic outstanding exposure with delinquency rates to identify regions requiring closer portfolio monitoring.

**5. Develop Consistent Portfolio Reporting**

Maintain standardized KPI definitions, reporting snapshots, and data validation procedures to support accurate and consistent financial and risk reporting.

## 11. Project Limitations

This project is based entirely on synthetic lending data.

The data was designed for analytical practice and portfolio demonstration. Therefore, the observed delinquency rates, lender comparisons, and borrower risk patterns do not represent actual industry conditions.

Key limitations include:

- Synthetic repayment behavior may not reflect real lending dynamics.
- Risk segment classifications are simulated.
- Portfolio comparisons may be influenced by loan age, tenor, and borrower composition.
- Outstanding and delinquency metrics represent a single reporting snapshot.
- The analysis identifies associations and risk concentrations, not causal relationships.

The recommendations are illustrative and would require further validation before application in a real lending environment.

## 12. Project Deliverables

The repository contains:

- **data/** — Synthetic lending datasets and analytical snapshot
- **sql/** — SQL scripts for exploration, financial calculations, and delinquency analysis
- **notebooks/** — SQL analysis notebooks
- **dashboard/** — Power BI report file
- **images/** — Dashboard screenshots
- **analysis/** — Business findings and supporting documentation
- **README.md** — Complete project documentation

## 13. Conclusion

This project demonstrates an end-to-end Business Intelligence workflow, from understanding business requirements and preparing relational datasets to calculating financial metrics, validating results, developing interactive dashboards, and communicating analytical findings.

By combining SQL-based data analysis with Power BI reporting, the project illustrates how data analytics can support loan portfolio monitoring, credit risk assessment, and business decision-making.

The project also highlights the importance of data quality, consistent metric definitions, and business-focused analytical communication.

---

## About the Author

**Tetty Vera Simbolon**

*Business Intelligence Analyst | Data Analyst*

Background in business intelligence, financial reporting, data reconciliation, operational analytics, and dashboard development.

Technical skills include SQL, AWS Athena, Metabase, Power BI, Excel, and data analytics.

**Open to international remote opportunities in Data Analytics and Business Intelligence.**
