# Part D — AI assistant audit log

## D1.1 — Five-part prompt for Part A q13

**Role**  
You are a careful SQL analyst working with a small sales database. Produce a correct, executable query and do not invent schema details.

**Task**  
Write Part A's q13 query: calculate each sales representative's revenue for each order month, compare it with that representative's monthly target, and assign a performance tier. Return the representative name, month, monthly target, revenue, and performance tier.

**Context**  
Use the real SQLite-compatible schema below:
- `reps(rep_id, rep_name, region, monthly_target)`
- `customers(customer_id, first_name, last_name, city, region, age, rep_id)`
- `orders(order_id, customer_id, item, quantity, amount, status, order_month)`
Join `reps` to `customers` on `rep_id`, then join `customers` to `orders` on `customer_id`. Revenue is `SUM(orders.amount)`. The SQL dialect is SQLite-compatible SQL.

**Constraints**  
Include completed orders only (`orders.status = 'completed'`). Use these three tiers based on monthly revenue compared with `monthly_target`: **Below Target** when revenue is below 100% of target; **On Target** when revenue is at least 100% but below 110% of target; **Above Target** when revenue is at least 110% of target. Do not use `WITH` clauses or stored procedures. Aggregate at representative-and-month level and group all non-aggregated selected columns correctly. Use only the stated tables and columns.

**Format**  
Return raw SQL only, with concise inline comments explaining important join/filter/aggregation choices. Do not include prose outside the SQL.

## D1.2 — Defects in the assistant's original answer

| Defect | Classification | Why it is defective | Correct clause or fix |
|---|---|---|---|
| `FROM sales` refers to a table that does not exist in the seed schema. | fake method/function | The real order facts are in `orders`; region is available through `customers`. | Join `orders AS o` to `customers AS c` on `o.customer_id = c.customer_id`. |
| `region_name` and `total_sales` are not real columns in the seed schema. | fake method/function | `customers` has `region`; `orders` has `amount`. | Select `c.region` and calculate `SUM(o.amount) AS revenue`. |
| `WHERE SUM(total_sales) > 80000` applies an aggregate in `WHERE`. | logic error | `WHERE` filters source rows before grouping; aggregate conditions belong in `HAVING`. | Use `HAVING SUM(o.amount) > 80000` after grouping. Keep completed-order filtering in `WHERE`. |
| “North's revenue grew 38% month over month” is not supported by the query or data. | phantom statistic | The verified q11 result shows North at 53,500 in 2026-09 and 41,300 in 2026-10, which is a decline. | Calculate the change from the q11 monthly values and report the actual percentage, not an invented claim. |

## D1.3 — Corrected query and execution evidence

Saved as `sql/d1_corrected.sql` and executed against the seed workbook's `reps`, `customers`, and `orders` tables using SQLite-compatible SQL. The query filters to completed orders, groups by the actual customer region, applies the 80,000 cutoff in `HAVING`, and sorts revenue descending.

```sql
-- Revenue by region for completed orders only; retain regions above the 80,000 threshold.
-- HAVING is used because the threshold applies to the grouped SUM.
SELECT c.region AS region,
       SUM(CAST(o.amount AS NUMERIC)) AS revenue
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(CAST(o.amount AS NUMERIC)) > 80000
ORDER BY revenue DESC;
```

**Executed result (exactly 2 rows):**

| region | revenue |
|---|---:|
| North | 119300 |
| South | 82500 |

**North month-over-month check using q11:**

| Month | North revenue |
|---|---:|
| 2026-09 | 53,500 |
| 2026-10 | 41,300 |

Calculation: `((41,300 - 53,500) / 53,500) × 100 = -22.8%` (rounded to one decimal place). **The assistant's 38% growth claim is contradicted by the data**: North revenue decreased by 22.8% from September to October.

## D1.4 — Human-in-the-loop protocol

**Specification.** I translated the vague question “which regions sell the most?” into a testable request: sum `amount` by the actual `customers.region`, count completed orders only, keep regions with revenue strictly greater than 80,000, and sort highest first. I explicitly treated the 38% claim as unverified until checked against q11.

**Execution.** I replaced the nonexistent `sales` table and made the join path explicit (`orders` → `customers`). I executed `sql/d1_corrected.sql` against the seed data in SQLite-compatible SQL. It returned exactly North (119300) and South (82500), both above 80,000.

**Inspection.** I checked the query against the real schema: `orders` contains `amount`, `status`, `customer_id`, and `order_month`; `customers` contains `region` and `customer_id`. The aggregate cutoff is in `HAVING`, while `WHERE` filters individual rows to `status = 'completed'`. The result has the expected two columns and two rows.

**Verification.** The result's total is 201,800 across the two qualifying regions; the region/category and region summaries in the Part C work reconcile to overall completed revenue of 346,200. Independently, q11 reports North revenue of 53,500 for 2026-09 and 41,300 for 2026-10; the calculated change is −22.8%, not +38%.

**Decision.** **Reject the original answer** because it references a nonexistent table and columns, places an aggregate in `WHERE`, and makes a phantom 38% growth claim contradicted by q11. **Accept the corrected version** because it executes against the seed schema, returns exactly the two qualifying regions (North 119300; South 82500), applies completed-only filtering and the strict `> 80000` threshold correctly, and its trend check matches q11.

## D2 — Formula troubleshooting prompt and repair

### Five-part prompt

**Role**  
You are a spreadsheet troubleshooting specialist. Diagnose the cause before proposing a formula change.

**Task**  
Explain why a lookup returns “value not found” and give a repaired formula that returns the matching product's unit price.

**Context**  
The workbook has a `products` tab occupying `A1:C10`: headers are in row 1, item names are in column A, and unit prices are in column C. The formula is being entered on the `orders` tab. Cell `orders!G2` contains the text ` Smart Watch`, with one leading space before `Smart Watch`. The current formula is `=VLOOKUP(G2, $A$2:$C$10, 3, FALSE)`. The product name `Smart Watch` exists in the products table.

**Constraints**  
Use an exact match; do not change the source data; account for the leading whitespace; and explicitly reference the `products` tab from the `orders` tab.

**Format**  
State the root cause in plain language, then provide one repaired Excel formula and briefly explain the repair.

### Root cause and repaired formula

The lookup key in `orders!G2` begins with a leading space, so exact-match `VLOOKUP` looks for ` Smart Watch` rather than `Smart Watch`. Also, because the formula is on the `orders` tab, the lookup range should explicitly point to the `products` tab instead of the local `$A$2:$C$10` range.

Repaired formula:

```excel
=VLOOKUP(TRIM(G2), products!$A$2:$C$10, 3, FALSE)
```

`TRIM(G2)` removes the leading space, `products!$A$2:$C$10` selects the correct lookup table, `3` returns the unit-price column, and `FALSE` requires an exact match.

## Part C — Skeptical-analyst challenge to recommendation 1

### Prompt to the assistant

**Act as a skeptical analyst.** Challenge this recommendation from my Part C dashboard: “North Electronics has revenue of ₹73,400, so run a promotion to grow sales.” Do not simply repeat the correlation or assume the recommendation is correct. Identify the unstated assumptions, ask what evidence would establish a cause-and-effect relationship, and propose specific checks using the available order data. Distinguish what the data directly shows from what it cannot establish; do not invent customer demand, margins, stock availability, or promotion effects.

### Unstated assumptions and data checks

1. **Assumption: North Electronics has an unusually weak sales opportunity that a promotion could improve.** The data establishes ₹73,400 in North Electronics revenue, but that alone does not prove underperformance or unmet demand. Compare North Electronics' revenue with other region-category cells and compare month-by-month North Electronics revenue; use order counts and units as well as revenue to see whether the amount reflects many orders or a few large ones.
2. **Assumption: the revenue is profitable enough to justify a discount.** The available dataset has sales amounts and unit prices but no cost or margin field. Check whether costs/margins can be obtained from another trusted source before approving a discount. If margin data is unavailable, mark promotion profitability as unverified rather than treating revenue as profit.
3. **Assumption: low stock or low awareness is not the real constraint, and inventory can support more demand.** The order data does not include inventory, stock-outs, or marketing exposure. Check inventory/stock-out records and promotion history for North Electronics by month. If those records do not exist, the cause of the current sales level remains unknown.
4. **Assumption: the ₹73,400 is a stable pattern rather than a month-specific spike.** Compare North Electronics revenue, order count, and units for 2026-09, 2026-10, and 2026-11 using `orders` joined to `customers`, grouped by month and category. A concentrated one-month spike would weaken the claim that a general promotion is needed; a sustained pattern plus independent demand evidence would strengthen further investigation.

**Analyst conclusion:** ₹73,400 is a descriptive result, not evidence that a promotion will cause growth. Treat the promotion as a hypothesis to test, ideally with a controlled or phased comparison and a margin measure, rather than as a proven action.
