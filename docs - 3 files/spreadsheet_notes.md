# Spreadsheet Notes — Part B

## Setup

- Workbook tabs created: `orders`, `products`, and `completed_orders` (the completed tab also contains the statistics block and both pivot summaries to the right of the export range).
- Imported **90 rows** into `orders` from `data/orders_enriched.csv`; `order_month` was kept as text (for example, `2026-09`) before sorting/pivoting.
- `products` contains 9 product records plus the header in **A1:C10**; source query: `SELECT item, category, unit_price FROM products ORDER BY item` (results pasted with header).
- Applied `status = completed` filter, then sorted visible rows by `amount` largest-to-smallest; copied the 63 visible rows as values to `completed_orders`. Removed raw `first_name` and `last_name`; retained cleaned name columns.
- Missing-key test: `=XLOOKUP(Q2,products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")` with `Q2` containing `Mystery Item` displayed **`UNKNOWN_ITEM`**.

## Formulas (first data row)

| Added column | Formula typed in first data row |
|---|---|
| `clean_first_name` | `=PROPER(TRIM(C2))` |
| `clean_last_name` | `=PROPER(TRIM(D2))` |
| `category` | `=VLOOKUP(G2,products!$A$2:$C$10,2,FALSE)` |
| `unit_price` | `=XLOOKUP(G2,products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")` |
| `revenue_calc` | `=N2*H2` |

## Amount aggregates (completed orders)

| Statistic | Result |
|---|---:|
| COUNT | 63 |
| SUM | 346200 |
| AVERAGE | 5495.24 |
| MIN | 1100 |
| MAX | 15600 |

## Pivot (i): Sum of amount by category and region

| Category | East | North | South | West | Grand Total |
|---|---:|---:|---:|---:|---:|
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |
| **Grand Total** | 69500 | 119300 | 82500 | 74900 | 346200 |

## Pivot (ii): Sum of amount and count of order_id by order_month

| order_month | Sum of amount | Count of order_id |
|---|---:|---:|
| 2026-09 | 98300 | 19 |
| 2026-10 | 93100 | 20 |
| 2026-11 | 154800 | 24 |
| **Grand Total** | 346200 | 63 |

## Reconciliation with Part A q05

| Metric | Spreadsheet | Part A q05 | Status |
|---|---:|---:|---|
| COUNT | 63 | 63 | Match |
| SUM | 346200 | 346200 | Match |
| AVERAGE | 5495.24 | 5495.24 | Match |

## Data validation

- **Missing amounts:** The three blank amounts are order IDs **1001, 1010, and 1064**, as identified by Part A q02. All three are `pending`, not completed, so they were left blank (not converted to zero or imputed); this preserves the source meaning and does not affect completed-order aggregates.
- **Consistent data types:** `order_id`, `quantity`, `unit_price`, `amount`, and `revenue_calc` are numeric values in the workbook/CSV; `order_month` is explicitly retained as text in `YYYY-MM` form. Name fields and category/region/status/item fields are text.
- **Duplicate order IDs among completed orders:** None.
 - **Largest amount / outlier review:** Largest completed-order amount is **15600**; order IDs with this amount: **1061, 1065, 1069, 1077**. These are the high end of the dataset; they match the product price pattern in the source data and are not automatically removed as errors.
- **Handoff decision:** Keep `amount` as the source transaction value and `revenue_calc` as a separate unit-price-times-quantity check; investigate any future disagreement rather than silently overwriting the source amount.
