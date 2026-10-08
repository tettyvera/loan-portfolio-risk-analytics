# Loan Portfolio Performance & Risk Analytics — Findings

**Project:** Simulated digital lending portfolio (synthetic data only)  
**As-of date:** August 31, 2026  
**Currency:** IDR  
**Method:** One row per loan, based on installment schedules and actual payments received through the as-of date.

## Executive summary

In the simulated portfolio, cumulative disbursement reached **IDR 31.7044 billion** across **2,000 loans**. Outstanding principal was **IDR 9.5928 billion**, with **1,648 loans** carrying a positive principal balance. Of the outstanding principal, **59.98%** was on loans more than 30 days past due (DPD > 30). Because the dataset intentionally simulates delinquency, these figures should not be generalized to any real lender or market.

## KPI definitions

| KPI | Definition |
| --- | --- |
| Cumulative disbursement | Total principal originated on or before 2026-08-31 |
| Outstanding principal | Sum of scheduled installment principal that remains unpaid as of 2026-08-31; equivalent to disbursement less principal paid for this simulated dataset |
| Overdue principal | Unpaid scheduled principal where due date is earlier than 2026-08-31 |
| Days past due (DPD) | Days since the earliest due date of an unpaid overdue installment; set to zero if no installments are overdue |
| PAR >30 | Outstanding principal on loans with DPD >30 / total outstanding principal |
| PAR 90+ | Outstanding principal on loans with DPD >=90 / total outstanding principal |

**Important:** PAR is *balance weighted*. The denominator is outstanding principal, not cumulative disbursement and not loan count. The definitions are for the learning project, not formal regulatory classification.

## Portfolio snapshot

| Metric | Result |
| --- | ---: |
| Number of loans | 2,000 |
| Loans with outstanding principal | 1,648 |
| Cumulative disbursement | IDR 31.7044 billion |
| Outstanding principal | IDR 9.5928 billion |
| Overdue principal | IDR 4.1742 billion |
| Loans with DPD >30 | 1,286 |
| PAR >30 | 59.98% |
| PAR 90+ | 48.89% |

## Lender comparison

| Lender | Cumulative disbursement | Outstanding principal | PAR >30 |
| --- | ---: | ---: | ---: |
| Meridian Capital | IDR 12.5000 bn | IDR 3.3860 bn | 54.47% |
| Crescent Lending | IDR 8.3818 bn | IDR 2.6272 bn | 57.74% |
| Harbor Finance | IDR 6.5750 bn | IDR 2.2121 bn | 68.50% |
| Summit Credit | IDR 4.2476 bn | IDR 1.3675 bn | 64.17% |

**Finding:** Meridian Capital contributed the largest cumulative disbursement, but Harbor Finance showed the highest PAR >30. A bigger lending portfolio does not automatically mean poorer portfolio quality; disbursement and credit-risk exposure measure different things.

## Borrower risk segment comparison

| Segment | Outstanding principal | PAR >30 |
| --- | ---: | ---: |
| High | IDR 1.7490 bn | 85.25% |
| Medium | IDR 3.7270 bn | 66.29% |
| Low | IDR 4.1168 bn | 43.54% |

**Interpretation limitation:** Payment probabilities were explicitly set by segment in the synthetic data generator. The result is a demonstration of analytical segmentation, **not** independent proof that borrower characteristics determine credit outcomes.

## Potential stakeholder follow-ups

1. **Investigate aging exposure:** Identify simulated loan cohorts with high DPD and high balances; distinguish total overdue *installment principal* from the *entire outstanding principal* of delinquent loans.
2. **Compare lenders fairly:** Segment by disbursement vintage, original tenor, and borrower risk mix before attributing observed differences to lenders.
3. **Review simulation assumptions:** Distinguish the intended stress-test behavior of synthetic payment generation from real collections performance.

## Data integrity

- Each loan has one borrower and one lender.
- Repayments are aggregated to installment level before joining with schedules.
- No negative installment balances or overpayments in the source data.
- Reconciliation: cumulative disbursement − principal repaid = outstanding principal (difference: IDR 0.00).

## Limitations

Synthetic data only. This exercise omits charge-offs, partial principal allocation beyond the provided fields, restructures, payment reversals, loan purchases, fees, and formal regulatory NPL rules. DPD and PAR are simplified learning metrics. These numbers should not be used for real credit decisions.
