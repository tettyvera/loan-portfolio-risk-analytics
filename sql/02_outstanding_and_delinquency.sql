-- Loan Portfolio Performance & Risk Analytics
-- Lesson 5: Outstanding Principal & Delinquency
-- SQL dialect: DuckDB
-- Synthetic data, snapshot date: 2026-08-31 (end of day)
-- All currency amounts are IDR; accrued interest excluded from outstanding principal.
-- Prerequisite: read CSVs into DuckDB views: loans, installments, repayments,
-- borrowers, lenders (Lesson 4).
-- IMPORTANT: execute sections in order. All calculations use payment dates <= snapshot.

-- STEP 1. Aggregate repayments FIRST: otherwise joining each loan to many
-- installments / payments can duplicate the loan principal.
CREATE OR REPLACE VIEW v_installment_payments AS
SELECT
    installment_id,
    SUM(CAST(principal_paid AS DECIMAL(18, 2))) AS principal_paid,
    SUM(CAST(interest_paid AS DECIMAL(18, 2))) AS interest_paid
FROM repayments
WHERE CAST(payment_date AS DATE) <= DATE '2026-08-31'
GROUP BY installment_id;

-- STEP 2. Compare scheduled installment amounts with payments.
-- Future scheduled installments remain outstanding, but NOT overdue.
CREATE OR REPLACE VIEW v_installment_snapshot AS
WITH balances AS (
    SELECT
        i.installment_id,
        i.loan_id,
        CAST(i.due_date AS DATE) AS due_date,
        CAST(i.principal_due AS DECIMAL(18, 2)) AS principal_due,
        CAST(i.interest_due AS DECIMAL(18, 2)) AS interest_due,
        COALESCE(p.principal_paid, 0) AS principal_paid,
        COALESCE(p.interest_paid, 0) AS interest_paid,
        GREATEST(
            CAST(i.principal_due AS DECIMAL(18, 2)) - COALESCE(p.principal_paid, 0), 0
        ) AS remaining_principal,
        GREATEST(
            CAST(i.interest_due AS DECIMAL(18, 2)) - COALESCE(p.interest_paid, 0), 0
        ) AS remaining_interest
    FROM installments AS i
    LEFT JOIN v_installment_payments AS p
        ON i.installment_id = p.installment_id
)
SELECT
    *,
    CASE
        WHEN due_date < DATE '2026-08-31'
             AND remaining_principal + remaining_interest > 0
        THEN DATE_DIFF('day', due_date, DATE '2026-08-31')
        ELSE 0
    END AS installment_dpd,
    CASE
        WHEN due_date < DATE '2026-08-31'
        THEN remaining_principal
        ELSE 0
    END AS overdue_principal
FROM balances;

-- STEP 3. Make ONE row per loan (safe to join to loan dimensions).
CREATE OR REPLACE VIEW v_loan_snapshot AS
WITH rollup AS (
    SELECT
        loan_id,
        SUM(remaining_principal) AS outstanding_principal,
        SUM(overdue_principal) AS overdue_principal,
        MAX(installment_dpd) AS dpd
    FROM v_installment_snapshot
    GROUP BY loan_id
)
SELECT
    l.loan_id,
    l.borrower_id,
    l.lender_id,
    CAST(l.disbursement_date AS DATE) AS disbursement_date,
    CAST(l.principal_amount AS DECIMAL(18, 2)) AS disbursed_principal,
    COALESCE(r.outstanding_principal, 0) AS outstanding_principal,
    COALESCE(r.overdue_principal, 0) AS overdue_principal,
    COALESCE(r.dpd, 0) AS dpd,
    CASE
        WHEN COALESCE(r.outstanding_principal, 0) = 0 THEN 'Paid off'
        WHEN COALESCE(r.dpd, 0) = 0 THEN 'Current'
        WHEN r.dpd BETWEEN 1 AND 30 THEN '1-30'
        WHEN r.dpd BETWEEN 31 AND 60 THEN '31-60'
        WHEN r.dpd BETWEEN 61 AND 89 THEN '61-89'
        ELSE '90+'
    END AS dpd_bucket
FROM loans AS l
LEFT JOIN rollup AS r ON l.loan_id = r.loan_id
WHERE CAST(l.disbursement_date AS DATE) <= DATE '2026-08-31';

-- QUESTION A: Overall portfolio health
-- PAR >30 = SUM(outstanding on loans with DPD > 30) / total outstanding
-- PAR 90+ = SUM(outstanding on loans with DPD >= 90) / total outstanding
SELECT
    COUNT(*) AS total_loans,
    COUNT(*) FILTER (WHERE outstanding_principal > 0) AS loans_with_outstanding,
    SUM(disbursed_principal) AS cumulative_disbursement_idr,
    SUM(outstanding_principal) AS outstanding_principal_idr,
    SUM(overdue_principal) AS overdue_principal_idr,
    COUNT(*) FILTER (WHERE dpd > 0) AS delinquent_loans,
    COUNT(*) FILTER (WHERE dpd > 30) AS loans_dpd_over_30,
    ROUND(
        100.0 * SUM(CASE WHEN dpd > 30 THEN outstanding_principal ELSE 0 END)
        / NULLIF(SUM(outstanding_principal), 0), 2
    ) AS par_over_30_pct,
    ROUND(
        100.0 * SUM(CASE WHEN dpd >= 90 THEN outstanding_principal ELSE 0 END)
        / NULLIF(SUM(outstanding_principal), 0), 2
    ) AS par_90_plus_pct
FROM v_loan_snapshot;

-- QUESTION B: What is the outstanding distribution across DPD buckets?
SELECT
    dpd_bucket,
    COUNT(*) AS loan_count,
    SUM(outstanding_principal) AS outstanding_principal_idr,
    SUM(overdue_principal) AS overdue_principal_idr,
    ROUND(
        100.0 * SUM(outstanding_principal)
        / NULLIF((SELECT SUM(outstanding_principal) FROM v_loan_snapshot), 0), 2
    ) AS share_of_total_outstanding_pct
FROM v_loan_snapshot
GROUP BY dpd_bucket
ORDER BY CASE dpd_bucket
    WHEN 'Paid off' THEN 0 WHEN 'Current' THEN 1
    WHEN '1-30' THEN 2 WHEN '31-60' THEN 3
    WHEN '61-89' THEN 4 ELSE 5 END;

-- QUESTION C: Which lender has a higher share of delinquent outstanding?
SELECT
    ld.lender_name,
    COUNT(*) AS total_loans,
    SUM(s.disbursed_principal) AS cumulative_disbursement_idr,
    SUM(s.outstanding_principal) AS outstanding_principal_idr,
    ROUND(
        100.0 * SUM(CASE WHEN s.dpd > 30 THEN s.outstanding_principal ELSE 0 END)
        / NULLIF(SUM(s.outstanding_principal), 0), 2
    ) AS par_over_30_pct
FROM v_loan_snapshot AS s
JOIN lenders AS ld ON s.lender_id = ld.lender_id
GROUP BY ld.lender_name
ORDER BY par_over_30_pct DESC;

-- QUESTION D: Which predefined risk segments have the highest PAR >30?
SELECT
    b.risk_segment,
    COUNT(*) AS total_loans,
    SUM(s.outstanding_principal) AS outstanding_principal_idr,
    ROUND(
        100.0 * SUM(CASE WHEN s.dpd > 30 THEN s.outstanding_principal ELSE 0 END)
        / NULLIF(SUM(s.outstanding_principal), 0), 2
    ) AS par_over_30_pct
FROM v_loan_snapshot AS s
JOIN borrowers AS b ON s.borrower_id = b.borrower_id
GROUP BY b.risk_segment
ORDER BY par_over_30_pct DESC;

-- QUALITY CHECK A: no overpaid installments / negative unpaid balances.
SELECT
    COUNT(*) FILTER (WHERE remaining_principal < 0 OR remaining_interest < 0)
        AS negative_installment_balances,
    COUNT(*) FILTER (WHERE principal_paid > principal_due OR interest_paid > interest_due)
        AS overpaid_installments
FROM v_installment_snapshot;

-- QUALITY CHECK B: total disbursement less total principal paid
-- must equal outstanding from the installment schedule (to within IDR 0.01).
SELECT
    SUM(s.disbursed_principal) AS disbursed_idr,
    (SELECT SUM(CAST(principal_paid AS DECIMAL(18,2)))
       FROM repayments WHERE CAST(payment_date AS DATE) <= DATE '2026-08-31')
        AS principal_paid_idr,
    SUM(s.outstanding_principal) AS outstanding_idr,
    SUM(s.disbursed_principal) -
    (SELECT SUM(CAST(principal_paid AS DECIMAL(18,2)))
       FROM repayments WHERE CAST(payment_date AS DATE) <= DATE '2026-08-31') -
    SUM(s.outstanding_principal) AS reconciliation_difference_idr
FROM v_loan_snapshot AS s;
