# BBD Regional Performance Review

## SQL Details

* **SQL Compiler:** \[One Compiler]
* **SQL Dialect:** \[My SQL]

## Spreadsheet Tool

* Google Sheets - MS Excel

## Tableau Public

* \[Yes]

## Key Findings

1. North led with ₹119,300 out of ₹346,200 in total revenue.
2. Revenue increased by 66.3% in October. *(Verify the comparison
period and percentage against your SQL results.)*
3. North revenue fell every month. *(Verify using your SQL output.)*

## File Index

File                         Part

\---

`sql/q01.sql`                A
`sql/q02.sql`                A
`sql/q03.sql`                A
`sql/q04.sql`                A
`sql/q05.sql`                A
`sql/q06.sql`                A
`sql/q07.sql`                A
`data/orders\\\_enriched.csv`   B
`docs/dashboard\\\_spec.md`     C
`docs/ai\\\_log.md`             D
`README.md`                  Project overview

## Assumptions

1. Revenue calculations follow the order-status rules defined in the
SQL queries.
2. Missing values are not automatically treated as zero.
3. The `order\\\_month` field remains text in `YYYY-MM` format.
4. Unmatched products are identified and handled consistently.
5. Dashboard figures are checked against SQL query results.

