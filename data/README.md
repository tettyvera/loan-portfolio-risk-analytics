# Synthetic Loan Portfolio Dataset

This dataset is entirely **synthetic**. No real customer, loan, lender, or employer records are used.

**Analysis snapshot:** 2026-08-31  
**Currency:** Indonesian rupiah (IDR)  
**Dates:** ISO format (`YYYY-MM-DD`)  
**Amounts:** numeric strings using a dot as the decimal separator; no currency symbols or thousands separators  
**Data generation:** fixed random seed `20261008` using `generate_synthetic_data.py`.

## Files and columns

### `borrowers.csv` — 1,500 rows
| Column | Meaning |
|---|---|
| `borrower_id` | Unique borrower identifier (primary key) |
| `province` | Fictional borrower's Indonesian province |
| `age_group` | Borrower age band |
| `risk_segment` | Synthetic borrower classification: Low, Medium, or High |

### `lenders.csv` — 4 rows
| Column | Meaning |
|---|---|
| `lender_id` | Unique lending partner identifier (primary key) |
| `lender_name` | Fictional lender name |
| `lender_type` | Fictional lender category |

### `loans.csv` — 2,000 rows
| Column | Meaning |
|---|---|
| `loan_id` | Unique loan identifier (primary key) |
| `borrower_id` | Foreign key to `borrowers.borrower_id` |
| `lender_id` | Foreign key to `lenders.lender_id` |
| `disbursement_date` | Loan principal disbursed on this date |
| `principal_amount` | Loan principal in IDR |
| `tenor_months` | Number of scheduled monthly installments |

### `installments.csv` — 19,458 rows
| Column | Meaning |
|---|---|
| `installment_id` | Unique installment identifier (primary key) |
| `loan_id` | Foreign key to `loans.loan_id` |
| `installment_number` | Number of the monthly installment within a loan |
| `due_date` | Contractual installment due date |
| `principal_due` | Scheduled principal component in IDR |
| `interest_due` | Scheduled interest component in IDR |

### `repayments.csv` — 13,641 rows
| Column | Meaning |
|---|---|
| `repayment_id` | Unique repayment identifier (primary key) |
| `installment_id` | Foreign key to `installments.installment_id` |
| `loan_id` | Foreign key to `loans.loan_id`, repeated for convenience |
| `payment_date` | Actual payment date (on or before snapshot) |
| `principal_paid` | Principal paid in IDR |
| `interest_paid` | Interest paid in IDR |

## Data model

- `borrowers` (1) → (many) `loans`
- `lenders` (1) → (many) `loans`
- `loans` (1) → (many) `installments`
- `installments` (1) → (zero or many) `repayments`

`repayments` contains records paid on or before 2026-08-31 only. `installments` includes scheduled future due dates, so **future installments should not be marked overdue**.

## Important KPI definitions

- **Total disbursement:** sum of `loans.principal_amount` for loans disbursed on/before the snapshot.
- **Outstanding principal:** disbursed principal minus principal payments received on/before the snapshot. This includes both current and overdue principal.
- **Overdue principal:** unpaid `principal_due` amounts from installments whose `due_date` is **before** the snapshot date; interest is excluded.
- **Days past due (DPD), simplified:** days between the snapshot date and the earliest installment due date with unpaid scheduled amount, when overdue. Fully paid installments and future installments do not contribute.
- **Delinquency rate:** define denominator and numerator explicitly (for example, outstanding principal on DPD 1+ loans divided by total outstanding principal).

> These are learning definitions for synthetic data, not a production credit-risk or regulatory methodology. Actual PAR/NPL/default metrics may be defined differently and may require additional business rules.

## Notes and limitations

- Borrower risk segments and payment behavior are artificially generated; relationships may be built into the simulation, not learned from real borrowers.
- Annualized interest, amortization, prepayments, fees, write-offs, refinancing, restructures, reversals, and partial payment allocation are simplified or absent.
- Do not use this dataset for real credit decisions or generalize its patterns to real markets.
- The generator performs checks for key uniqueness, foreign-key integrity, scheduled principal allocation, payment caps, and snapshot boundaries.
