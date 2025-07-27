# 🏦 Bank Database System – SQL Project

This project simulates a full-fledged **Banking System** using **MySQL**, covering all core SQL concepts such as table design, relationships, transactions, stored procedures, triggers, and advanced queries.

---

## 📁 Project Structure

- `bank_project_schema.sql` – Full DDL to create the database schema
- `bank_project_inserts_corrected.sql` – INSERT statements with 100 rows per table
- `bank_project_triggers_procedures_views.sql` – Triggers, stored procedures, and views
- `bank_er_diagram.png` – ER diagram showing all relationships
- `sample_queries.sql` – Collection of real-world queries (see below)

---

## 🧱 Schema Overview

| Table           | Description                                 |
|----------------|---------------------------------------------|
| `Branch`        | Bank branches with location data            |
| `Customer`      | Customer information linked to branches     |
| `Account`       | Account details with balances               |
| `Employee`      | Bank employees and their positions          |
| `Loan`          | Customer loan details                       |
| `BankTransaction` | Records of deposits and withdrawals       |

---

## 📊 ER Diagram

![ER Diagram](bank%20er%20diagram%20.png)

---

## 🔥 Key Features

- ✅ Fully normalized relational schema
- ✅ 100+ rows of realistic test data
- ✅ Foreign key relationships
- ✅ Triggers for balance updates
- ✅ Stored procedures for deposit, withdraw, loan application
- ✅ Views for customer summaries
- ✅ Real-world analytical queries

---

## 🧠 Advanced Queries (examples)

- Customers with highest deposits in the past month
- Average balance by branch
- Top 3 branches by withdrawals
- Customers with loans but no deposits
- Most active employees (by customers served)
- Branch-wise transactions on a given day

---

## 🚀 How to Use

### 1. Setup Database
```bash
-- Open MySQL Workbench or CLI
SOURCE bank_project_schema.sql;
SOURCE bank_project_inserts_corrected.sql;
SOURCE bank_project_triggers_procedures_views.sql;
