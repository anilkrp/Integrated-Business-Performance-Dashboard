# Integrated Business Performance Dashboard

A complete end-to-end data analysis project — from raw CSV files to an interactive Power BI dashboard — providing a 360° view of business performance.

---

## Dashboard Preview

[Business Performance Dashboard](dashboard_preview.png)

---

## Problem Statement

Business data is often scattered across multiple files (customers, orders, products, employees, returns), making it hard to get a unified picture. This project solves that by combining all datasets into a structured database and visualising the key metrics in a single Power BI dashboard.

---

## Dataset Overview

| File | Description |
|------|-------------|
| `customers.csv` | 100 customers with ID, name, city, region |
| `departments.csv` | 10 departments (Sales, HR, IT, etc.) |
| `employees.csv` | 15 employees with salary, hire date, department |
| `orders.csv` | 250 orders with product, quantity, date, amount |
| `products.csv` | 440 products across 13 categories |
| `returns.csv` | 75 returns with reason codes |

---

## Technologies Used

- **Python** (Pandas, sqlite3) — data loading and cleaning
- **SQLite** — relational database for local analysis
- **SQL** — advanced queries for sales, customer, and employee analytics
- **Power BI** — interactive dashboard

---

## Repository Structure
```
├── data/                   # CSV source files
├── screenshots/            # Dashboard preview images
├── code.ipynb              # Jupyter notebook to load CSVs into SQLite
├── queries.sql             # All SQL queries used for analysis
├── orderflow.db            # SQLite database (auto-generated)
├── dashboard.pbix          # Power BI dashboard file
└── README.md
```

---

## Dashboard KPIs

| Metric | Value |
|--------|-------|
| Total Revenue | ₹14.01M |
| Total Orders | 250 |
| Total Customers | 84 |
| Average Order Value | ₹56.05K |
| Return Rate | 30% |

### Visualisations
- **Monthly Revenue Trend** — revenue fluctuation across all 12 months
- **Top 5 Products by Revenue** — Laptop (₹1.92M) leads, followed by Smartphone, Whirlpool Webcam, Nike Gaming Console, Smartwatch
- **Revenue by Region** — West dominates at 27.35%, followed by North (24.73%), South (19.06%), East (14.94%), Central (13.92%)
- **Return Reasons Breakdown** — Damaged and Late Delivery are the top return reasons (12 each)

---

## Key Insights

- **Revenue Concentration** — Top 5 products drive the majority of revenue, a classic Pareto pattern
- **High Return Rate** — 30% return rate; Damaged goods and Late Delivery are the leading causes, pointing to logistics and quality issues
- **Regional Performance** — West region leads in revenue (Mumbai, Ahmedabad, Pune)
- **Customer Behaviour** — High average order value of ₹56.05K suggests mostly premium purchases

---

## Getting Started

**1. Clone the repository**
```bash
git clone https://github.com/anilkrp/Integrated-Business-Performance-Dashboard.git
cd Integrated-Business-Performance-Dashboard
```

**2. Install dependencies**
```bash
pip install pandas
```

**3. Run the notebook**

Open `code.ipynb` and run all cells. This loads the CSVs and creates `orderflow.db`.

**4. Explore SQL queries**

Open `orderflow.db` in [DB Browser for SQLite](https://sqlitebrowser.org/) and run queries from `queries.sql`.

**5. Open the dashboard**

Open `dashboard.pbix` in Power BI Desktop and refresh the data source if needed.

---

## Author

**Anil Kumar**  
[GitHub](https://github.com/anilkrp)

---

*For educational and portfolio purposes. Feel free to use and adapt.*
