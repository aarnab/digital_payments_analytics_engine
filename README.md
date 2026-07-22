# Digital Payments & Merchant Analytics Engine

## Project Overview
This project simulates the backend relational database of a digital payments gateway (such as UPI/Wallets). It is designed to track transaction integrity, calculate success rate funnels, and identify high-risk anomalies in real-time.

### Key Features
* **Payment Success Rate Funnel (T-SQL):** Utilizes Common Table Expressions (CTEs) and Date/Time functions (`GETDATE`, `CAST`) to aggregate daily transaction volumes. It dynamically calculates success percentages across different payment methods (UPI, Wallet, Credit Card) to instantly flag gateway outages.
* **Real-Time Fraud Detection:** Implements advanced filtering (`HAVING`, `DATEADD`) to isolate and flag user accounts exhibiting high-frequency transaction failures within a rolling 60-minute window, mirroring enterprise risk-management systems.

## Tools Used
* **SQL Server (T-SQL):** Relational Database Schema Design, CTEs, Aggregations, Time-Series Filtering
