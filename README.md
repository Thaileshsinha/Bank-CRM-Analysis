# Bank Customer Analysis – Power BI & SQL

An end-to-end analytics project designed to identify customer churn drivers, regional trends, and engagement patterns using **SQL**, **Power Query**, and an **interactive Power BI dashboard**.  
The dataset covers **10,000 customers** across **France, Germany, and Spain**.

---

## Project Overview
The goal of this project was to analyze customer behavior, product usage, and churn risk across multiple geographies and demographics.  
The process included data modeling, SQL-based KPI computation, and Power BI dashboarding for decision-ready insights.

---

## Key Insights
- **Churn Rate:** 20.4% overall (~2,000 customers lost; ₹185.6M impact)  
- **Inactive Accounts:** 51.5% of customers are inactive  
- **Zero-Balance Accounts:** 4,000 customers hold zero balance  
- **High-Risk Region:** Germany churns at **32%**, despite active account usage  
- **Tenure Pattern:** Churn peaks at **4–5 years**, then stabilizes beyond 5 years  
- **Product Usage:** 1-product users churn at **28%**, while 2-product users are most stable (**7%**)  

---

## Data Model
The project uses a **Star Schema** for efficient relational querying.

**Fact Table:**  
- `bank_churn` – core transaction and churn data  

**Dimension Tables:**  
- `customerinfo` – demographics and joining date  
- `geographytype` – region details (France, Germany, Spain)  
- `creditcardtype` – card ownership mapping  
- `activecusttype` – activity status reference  
- `exittype` – churn/retention classification  

**bank_churn (Main Fields):**  
`CustomerId`, `CreditScore`, `Tenure`, `Balance`, `NumOfProducts`, `HasCrCard`, `IsActiveMember`, `Exited`

---

## ⚙️ Tools & Technologies
- **Power Query** – Data profiling and transformation  
- **SQL (MySQL)** – Data cleaning, aggregation, and churn metric derivation  
- **Power BI** – Dashboard creation, KPIs, and interactive analysis  

---

## Project Workflow
1. **Data Import & Setup** – Loaded raw CSV into Power Query, cleaned and loaded into SQL.  
2. **Data Preparation** – Created calculated fields (Exit_Year, Tenure_Group, Credit_Score_Category).  
3. **SQL Analysis** – Derived churn %, tenure distribution, product adoption, and regional segmentation.  
4. **Dashboard Creation** – Built Power BI report with slicers for Region, Credit Score, and Tenure.  

---

## Dashboard Features
- KPIs: **Churn %**, **Active vs Inactive**, **Avg Tenure**, **Zero-Balance Accounts**  
- Visuals: Churn by Year, Product Usage, Tenure, Region, and Credit Score  
- Slicers: Region, Gender, Credit Score, and Tenure  
- Conditional formatting to highlight high-risk customer clusters  

---

## Recommendations
- **Retention:** Introduce loyalty renewal offers at ~3.5 years to reduce churn during 4–5 year tenure.  
- **Cross-Sell:** Move 1-product users to 2-product bundles (Savings → Card → Loan).  
- **Reactivation:** Target inactive and zero-balance accounts with auto-sweep and RD incentives.  
- **Regional Focus:** Improve customer experience and fee transparency in Germany; promote activation in Spain.  
- **High-Value Customers:** Provide premium service tiers for excellent-credit customers to enhance loyalty.  

---

##  Key Learnings
- Designed a **Star Schema** for efficient relational analysis.  
- Created SQL logic to automate churn segmentation and KPI generation.  
- Built an interactive Power BI dashboard to visualize insights dynamically.  
