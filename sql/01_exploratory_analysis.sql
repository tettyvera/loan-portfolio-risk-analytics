-- Loan Portfolio Performance & Risk Analytics
-- Exploratory Data Analysis (EDA)
-- SQL dialect: DuckDB
-- Data: synthetic; analysis snapshot: 2026-08-31

-- Exploration 1: Preview Loan Data
SELECT *
FROM loans
LIMIT 5;

-- Exploration 2: Row Count by Table
SELECT 'borrowers' AS table_name, COUNT(*) AS total_rows FROM borrowers
UNION ALL
SELECT 'lenders', COUNT(*) FROM lenders
UNION ALL
SELECT 'loans', COUNT(*) FROM loans
UNION ALL
SELECT 'installments', COUNT(*) FROM installments
UNION ALL
SELECT 'repayments', COUNT(*) FROM repayments;

-- Exploration 3: Loan Disbursement by Lender
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

-- Exploration 4: Monthly Disbursement Trend
SELECT
    DATE_TRUNC('month', CAST(disbursement_date AS DATE)) AS disbursement_month,
    COUNT(*) AS loan_count,
    SUM(principal_amount) AS disbursement_idr
FROM loans
WHERE CAST(disbursement_date AS DATE) <= DATE '2026-08-31'
GROUP BY 1
ORDER BY 1;

-- Exploration 5: Referential Integrity Check
SELECT
  SUM(CASE WHEN b.borrower_id IS NULL THEN 1 ELSE 0 END) AS loans_without_borrower,
  SUM(CASE WHEN ld.lender_id IS NULL THEN 1 ELSE 0 END) AS loans_without_lender
FROM loans AS l
LEFT JOIN borrowers AS b ON l.borrower_id = b.borrower_id
LEFT JOIN lenders AS ld ON l.lender_id = ld.lender_id;

-- Exploration 6: Loan Data Quality Check
SELECT
    COUNT(*) AS total_loans,
    COUNT(*) FILTER (
        WHERE borrower_id IS NULL
    ) AS missing_borrower_id,
    COUNT(*) FILTER (
        WHERE lender_id IS NULL
    ) AS missing_lender_id,
    COUNT(*) FILTER (
        WHERE disbursement_date IS NULL
    ) AS missing_disbursement_date,
    COUNT(*) FILTER (
        WHERE principal_amount IS NULL
    ) AS missing_principal,
    COUNT(*) FILTER (
        WHERE principal_amount <= 0
    ) AS invalid_principal
FROM loans;


-- Exploration 7: Duplicate Reference ID Check

-- Check duplicate lender IDs
SELECT
    lender_id,
    COUNT(*) AS total_records
FROM lenders
GROUP BY lender_id
HAVING COUNT(*) > 1;

-- Check duplicate borrower IDs
SELECT
    borrower_id,
    COUNT(*) AS total_records
FROM borrowers
GROUP BY borrower_id
HAVING COUNT(*) > 1;
