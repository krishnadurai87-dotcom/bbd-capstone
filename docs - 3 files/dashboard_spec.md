# Part C — Tableau Public Dashboard Specification

## Data source

Connect Tableau Public to `data/orders_clean.csv`. Use the header row as field names. Set `order_month` to String/text to preserve labels such as `2026-09`; do not convert it to a date. Treat `order_id` as a Dimension because it is an identifier, not an additive measure. Set the four Measures to numeric types.

| Column | Classification | Notes |
|---|---|---|
| `order_id` | Dimension | Identifier; do not sum |
| `order_month` | Dimension | Text month label |
| `clean_first_name` | Dimension | Cleaned first name |
| `clean_last_name` | Dimension | Cleaned last name |
| `region` | Dimension | Sales region |
| `rep_name` | Dimension | Sales representative |
| `item` | Dimension | Product/item |
| `category` | Dimension | Product category; dashboard filter |
| `unit_price` | Measure | Numeric unit price |
| `quantity` | Measure | Numeric quantity |
| `amount` | Measure | Numeric order amount; primary revenue metric |
| `revenue_calc` | Measure | Numeric unit_price × quantity |
| `status` | Dimension | Status; source contains completed orders |

There are 9 Dimensions and 4 Measures. The CSV contains 63 completed orders. Use `SUM(amount)` for revenue charts and KPIs.

## KPI cards

- **Total Revenue:** `SUM(amount)` = **₹346,200 INR**.
- **Total Units Sold:** `SUM(quantity)` = **106 units**.

The Total Revenue KPI equals Part A q05 `total_revenue` (**346200**).

## Chart sheets

### 1. Revenue by Region

- **Chart type:** Horizontal bar chart.
- **Rows:** `region`.
- **Columns:** `SUM(amount)`.
- **Colour:** `region`.
- **Reason:** Sorted bars make regional revenue contributions easy to compare.
- **Sort:** Descending by `SUM(amount)`.

| Region | SUM(amount), INR |
|---|---:|
| North | 119,300 |
| South | 82,500 |
| West | 74,900 |
| East | 69,500 |
| **Grand Total** | **346,200** |

### 2. Revenue by Category

- **Chart type:** Horizontal bar chart.
- **Rows:** `category`.
- **Columns:** `SUM(amount)`.
- **Colour:** `category`.
- **Reason:** Bars compare revenue across the three product categories directly.
- **Sort:** Descending by `SUM(amount)`.

| Category | SUM(amount), INR |
|---|---:|
| Electronics | 142,300 |
| Home | 126,400 |
| Apparel | 77,500 |
| **Grand Total** | **346,200** |

### 3. Revenue Trend by Month and Category

- **Chart type:** Line chart.
- **Columns:** `order_month` (String, ascending: `2026-09`, `2026-10`, `2026-11`).
- **Rows:** `SUM(amount)`.
- **Colour:** `category` (one line per category).
- **Marks:** Line; show month and revenue in tooltips.
- **Reason:** Lines show category movement over ordered monthly periods.

| Order month | Apparel | Electronics | Home | Monthly total |
|---|---:|---:|---:|---:|
| 2026-09 | 24,700 | 43,000 | 30,600 | 98,300 |
| 2026-10 | 30,600 | 49,900 | 12,600 | 93,100 |
| 2026-11 | 22,200 | 49,400 | 83,200 | 154,800 |
| **Grand Total** | **77,500** | **142,300** | **126,400** | **346,200** |

### 4. Region x Category Detail

- **Chart type:** Text table (optionally use subtle highlight-table shading).
- **Rows:** `region`.
- **Columns:** `category`.
- **Colour:** `category`, or leave unassigned for a neutral text table.
- **Text/Label:** `SUM(amount)`, formatted as whole INR.
- **Reason:** A cross-tab exposes exact regional/category values for auditing and action planning.

| Region | Apparel | Electronics | Home | Region total |
|---|---:|---:|---:|---:|
| East | 10,600 | 21,400 | 37,500 | 69,500 |
| North | 19,400 | 73,400 | 26,500 | 119,300 |
| South | 10,000 | 28,700 | 43,800 | 82,500 |
| West | 37,500 | 18,800 | 18,600 | 74,900 |
| **Grand Total** | **77,500** | **142,300** | **126,400** | **346,200** |

## Dashboard layout

Top-to-bottom placement:

1. **KPI band first:** horizontal container with Total Revenue left and Total Units Sold right.
2. **Filter band directly below the KPIs:** horizontal container spanning the dashboard; place the `category` quick filter here as a multi-select dropdown, defaulting to All.
3. **Trend chart:** full-width vertical container with Revenue Trend by Month and Category.
4. **Comparison charts:** horizontal container with Revenue by Region on the left and Revenue by Category on the right.
5. **Detail table:** full-width vertical container at the bottom with Region x Category Detail.

Apply the `category` filter to all four worksheets using this data source: Revenue by Region, Revenue by Category, Revenue Trend by Month and Category, and Region x Category Detail. If KPI cards are implemented as worksheets, keep their measures subject to the same category selection. Turn on **Use as Filter** for Revenue by Region; clicking a region bar filters the trend, category comparison, and detail table to that region, and clearing the selection restores the broader view.

## Insight and recommendation narrative

### Visualization summary

The dashboard summarizes 63 completed orders worth **₹346,200** across four regions, three categories, and September–November 2026. Electronics is the largest category, North is the largest region, and November has the highest monthly revenue. The detail table reveals regional category strengths that are hidden by overall totals.

### Summary analysis

1. **Regional gap:** North contributes **₹119,300**, compared with East at **₹69,500**, a difference of **₹49,800**. North's Electronics revenue is **₹73,400**.
2. **Category mix:** Electronics totals **₹142,300**, exceeding Home at **₹126,400** by **₹15,900**; Apparel contributes **₹77,500**.
3. **Month-to-month movement:** total revenue rises from **₹93,100** in October to **₹154,800** in November, up **₹61,700**. Home rises from **₹12,600** to **₹83,200** over the same months.
4. **Local category strengths:** West has **₹37,500** in Apparel, the highest Apparel total among regions; South has **₹43,800** in Home.

### Recommendations

1. **North — grow Electronics:** North Electronics contributes **₹73,400**, the largest region/category cell. Run a targeted cross-sell or repeat-purchase promotion for Electronics in North; monitor North Electronics revenue and order count in the next period.
2. **West — sustain Apparel performance:** West Apparel contributes **₹37,500**, the highest Apparel total by region. Maintain stock of leading Apparel items and test a focused promotion; monitor West Apparel revenue and units sold against the prior period.
3. **Home — investigate and sustain the November surge, focusing on South:** Home revenue reached **₹83,200** in November versus **₹12,600** in October, and South contributes **₹43,800** in Home. Review the November stock/promotion drivers and protect availability of proven Home items in South; monitor monthly Home revenue, South Home revenue, and stock-outs.

## Reconciliation

| Reconciliation source | Revenue (INR) |
|---|---:|
| Total Revenue KPI (`SUM(amount)`) | 346,200 |
| Sum of Revenue by Region values | 346,200 |
| Sum of Revenue by Category values | 346,200 |
| Part B pivot grand total | 346,200 |
