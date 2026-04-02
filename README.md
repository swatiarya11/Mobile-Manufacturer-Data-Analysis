# Mobile-Manufacturer-Data-Analysis
SQL-based analysis of mobile sales data to derive business insights like top manufacturers, customer spending patterns, and sales trends across years and locations.

## 📌 Overview
This project analyzes mobile phone sales data using SQL.  
The dataset includes information about manufacturers, models, customers, locations, and transactions.

The objective is to extract meaningful business insights such as sales trends, top-performing manufacturers, and customer behavior.

---

## 📂 Dataset Structure
- **Dim_Manufacturer** – Manufacturer details  
- **Dim_Model** – Model information with pricing  
- **Dim_Customer** – Customer details  
- **Dim_Location** – Location (State, Zipcode, Country)  
- **Fact_Transactions** – Sales transactions data  

---

## 🎯 Key Analysis Performed
- Identified states with active customers since 2005  
- Analyzed top-performing manufacturers (year-wise)  
- Evaluated model-wise transactions across regions  
- Found cheapest mobile phones  
- Calculated average price for top manufacturers  
- Identified high-value customers (avg spend > 500)  
- Tracked consistent top-performing models (2008–2010)  
- Compared manufacturer performance across years  
- Identified manufacturers with sales gaps (2010 vs 2009)  
- Analyzed top customers with yearly spend trends and % change  

---

## 🛠️ Tools Used
- SQL (Joins, Aggregations, CTEs, Window Functions)

## 🚀 Conclusion
This project demonstrates how SQL can be used to analyze structured data and generate actionable insights for business decision-making.
