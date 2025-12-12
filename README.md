# 📊 SQL Data Warehouse & Analytics Project

A complete end-to-end Data Warehouse and Analytics solution built using **SQL Server**, following the **Medallion Architecture (Bronze → Silver → Gold)**.  
This project demonstrates how raw ERP & CRM data is ingested, cleansed, transformed, and modeled into analytics-ready datasets for reporting and insights.

---

## 👩‍💻 About the Author
**Kavya M**  
- 🌐 Portfolio: https://kavya-neon-verse.lovable.app  
- 💼 LinkedIn: https://www.linkedin.com/in/kavya-malempati-54910a361  
- 🧑‍💻 GitHub: https://github.com/malempatikavya0903/my-  

---

## 🏗 High-Level Architecture

Below is the Data Warehouse architecture I designed using **Draw.io**.

> Make sure this PNG is uploaded to your repository at: `docs/data_architecture.png`

![High-Level Architecture](docs/data_architecture.png)

---

## 📖 Project Overview

This repository contains everything required to build a production-style data warehouse using SQL Server and SQL-based ETL. It follows the Bronze → Silver → Gold medallion pattern:

- **Bronze**: Raw ingestion of CSV files (ERP, CRM) into SQL Server tables (no or minimal transformation).  
- **Silver**: Data cleaning, standardization, deduplication, and basic enrichment.  
- **Gold**: Business-ready star schema (fact & dimension tables / views) optimized for analytics and reporting.

Key deliverables:
- SQL ETL scripts (Bronze / Silver / Gold)
- Draw.io architecture & model files (and PNG exports)
- Data catalog & naming conventions
- Sample queries for analytics and reporting

---

## 🧩 Repository Structure

```text
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows ETL techniques & methods
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_architecture.png           # Exported PNG used in README
│   ├── data_flow.drawio                # Data flow diagram (Draw.io)
│   ├── data_flow.png                   # PNG exported data flow diagram
│   ├── data_models.drawio              # Data model diagrams (star schema)
│   ├── data_models.png                 # PNG of data models for GitHub
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   │    ├── load_erp_to_bronze.sql
│   │    ├── load_crm_to_bronze.sql
│   ├── silver/                         # Scripts for cleaning and transforming data
│   │    ├── transform_customers.sql
│   │    ├── transform_products.sql
│   │    ├── deduplicate_orders.sql
│   ├── gold/                           # Scripts for creating analytical models
│        ├── build_dim_customer.sql
│        ├── build_dim_product.sql
│        ├── build_fact_sales.sql
│
├── tests/                              # Test scripts and quality files
│   ├── dq_null_checks.sql
│   ├── dq_foreign_key_checks.sql
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
