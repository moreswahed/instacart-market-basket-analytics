# Instacart Market Basket Analytics

End-to-end data analysis project on the Instacart grocery dataset (`orders` and `order_products__prior`) using **SQL Server** and an **interactive 3-page HTML dashboard**.

## Project Overview

This project explores customer purchasing rhythm, basket size dynamics, product reorder behavior, and catalog hierarchy/data completeness across prior grocery orders.

### Key Analytical Areas
- **Peak Demand & Shopping Rhythm:** Order distribution across hours of the day (`0–23`) and days of the week (`0–6`).
- **Reorder Behavior & Basket Dynamics:** Reorder rates across departments, cart addition positions (`add_to_cart_order`), and reorder intervals (`days_since_prior_order`).
- **Product Hierarchy & Data Audit:** Department-to-aisle-to-product structure along with tracking `Unknown` / unmapped products.

## Key KPIs Tracked
- **Total Orders**
- **Total Items Sold**
- **Avg Basket Size**
- **Reorder Rate %**
- **Reordered Items**
- **Avg Add-to-Cart Order**
- **Total Products Ordered**
- **Unknown Items Sold & Unknown Share %**

## Repository Structure

- `sql/` — SQL scripts for data preparation, cleaning, and analysis.
- `dashboard/instacart_dashboard.html` — Interactive 3-page HTML dashboard.
- `assets/` — Dashboard screenshots (Overview.png`, `Products.png`, `Reorder_Behavior.png`).

## How to View the Dashboard

1. Download or clone the repository.
2. Open `dashboard/instacart_powerbi_dashboard-v2.html` in any web browser (Chrome, Edge, Firefox).
3. Switch between the 3 pages and use the top filters (`Day of Week`, `Time Period`, `Department`, `Product Status`) or click chart bars to cross-filter.
