-- Loan Portfolio Performance & Risk Analytics
-- Exploratory Data Analysis (EDA)
-- SQL dialect: DuckDB
-- Data: synthetic; analysis snapshot: 2026-08-31
-- First load your CSVs as tables/views named borrowers, lenders, loans, installments, repayments.

-- Exploration 1
SELECT *
FROM loans
LIMIT 5;

-- Exploration 2
SELECT 'borrowers' AS table_name, COUNT(*) AS total_rows FROM borrowers
UNION ALL
SELECT 'lenders', COUNT(*) FROM lenders
UNION ALL
SELECT 'loans', COUNT(*) FROM loans
UNION ALL
SELECT 'installments', COUNT(*) FROM installments
UNION ALL
SELECT 'repayments', COUNT(*) FROM repayments;

-- Exploration 3
SELECT
    ld.lender_name,
    COUNT(*) AS total_loans,
    SUM(l.principal_amount) AS total_disbursement_idr,
    ROUND(AVG(l.principal_amount), 0) AS avg_loan_size_idr
FROM loans AS l
JOIN lenders AS ld
    ON l.lender_id = ld.lender_id
WHERE CAST(l.disbursement_date AS DATE) <= DATE '2026-08-31'
GROUP BY ld.lender_name
ORDER BY total_disbursement_idr DESC;

-- Exploration 4
SELECT
    DATE_TRUNC('month', CAST(disbursement_date AS DATE)) AS disbursement_month,
    COUNT(*) AS loan_count,
    SUM(principal_amount) AS disbursement_idr
FROM loans
WHERE CAST(disbursement_date AS DATE) <= DATE '2026-08-31'
GROUP BY 1
ORDER BY 1;

-- Exploration 5
SELECT
  SUM(CASE WHEN b.borrower_id IS NULL THEN 1 ELSE 0 END) AS loans_without_borrower,
  SUM(CASE WHEN ld.lender_id IS NULL THEN 1 ELSE 0 END) AS loans_without_lender
FROM loans AS l
LEFT JOIN borrowers AS b ON l.borrower_id = b.borrower_id
LEFT JOIN lenders AS ld ON l.lender_id = ld.lender_id;
