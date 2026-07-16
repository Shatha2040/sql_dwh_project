

<img width="1983" height="793" alt="image" src="https://github.com/user-attachments/assets/65e9552f-8b00-43aa-b57b-6c8da9c68437" />

# 🏛 SQL Data Warehouse Project

> A complete end-to-end SQL Server Data Warehouse built using the Medallion Architecture (Bronze, Silver, Gold), transforming raw CRM and ERP data into business-ready analytical models through ETL, data cleansing, dimensional modeling, and comprehensive documentation.

---

# 📖 Table of Contents

- [Project Overview](#-project-overview)
- [Objectives](#-objectives)
- [High-Level Architecture](#-high-level-architecture)
- [Data Warehouse Implementation Workflow](#️-data-warehouse-implementation-workflow)
- [Data Lineage](#-data-lineage)
- [Source Systems](#-source-systems)
- [Bronze Layer](#-bronze-layer)
- [Silver Layer](#-silver-layer)
- [Gold Layer](#-gold-layer)
- [Business Logic](#-business-logic)
- [Sales Data Mart (Star Schema)](#-sales-data-mart-star-schema)
- [Data Quality](#-data-quality)
- [Documentation](#-documentation)
- [Technologies](#-technologies)
- [Project Structure](#-project-structure)
---

# 📌 Project Overview

Modern organizations collect data from multiple operational systems. However, this raw data is often inconsistent, duplicated, and difficult to analyze directly.

This project demonstrates the complete implementation of a SQL Server Data Warehouse that integrates CRM and ERP data into a centralized analytical environment following the **Medallion Architecture**.

The solution transforms raw operational data into trusted, business-ready datasets designed for reporting, business intelligence, and future analytical applications.

---

# 🎯 Objectives

The primary objectives of this project are:

- Design a scalable SQL Data Warehouse.
- Implement the Medallion Architecture.
- Integrate multiple source systems.
- Apply data cleansing and standardization.
- Implement business rules.
- Build a dimensional model using Star Schema.
- Generate analytics-ready datasets.
- Document every stage of the implementation lifecycle.

---
# 🏛️ Data Warehouse Architecture

Modern analytical platforms can be designed using different architectural approaches, each addressing specific business requirements and data processing needs.

The following diagram provides an overview of the most common modern data architectures, including **Data Warehouse**, **Data Lake**, **Data Lakehouse**, and **Data Mesh**. It also presents common Data Warehouse design approaches, such as **Kimball**, **Inmon**, **Data Vault**, and **Medallion Architecture**.

The architecture and approach adopted in this project are highlighted in the diagram, providing context before presenting the project's architecture and implementation in the following sections.

<p align="center">
<img width="1818" height="1698" alt="image" src="https://github.com/user-attachments/assets/6e55cb1e-e148-494a-8aa4-60bac30b3732" />
</p>

---
# 🏗 Project High-Level Architecture

The project follows the **Medallion Architecture**, organizing data into three logical layers that progressively improve data quality and usability.

<p align="center">
 <img width="2158" height="1420" alt="image" src="https://github.com/user-attachments/assets/e415fcdc-c37a-4b32-91e8-f8691ad68cc8" />
</p>

## Architecture Summary

| Layer | Purpose |
|--------|---------|
| 🥉 Bronze | Store raw source data exactly as received from source systems. |
| 🥈 Silver | Clean, standardize, validate, and enrich data for consistency. |
| 🥇 Gold | Deliver business-ready analytical models optimized for reporting and analytics. |

---

# ⚙️ Data Warehouse Implementation Workflow

Building the Data Warehouse followed a structured process across each Medallion layer. Every stage includes analysis, implementation, validation, and documentation to ensure high-quality and reliable data delivery.

<p align="center">
 <img width="1214" height="1500" alt="image" src="https://github.com/user-attachments/assets/798976b1-7089-418d-b425-6ace2731936a" />
</p>

## Workflow Summary

| Layer | Main Activities |
|--------|-----------------|
| 🥉 Bronze | Analyze source systems, ingest raw data, validate loading, and document ETL processes. |
| 🥈 Silver | Analyze data, perform cleansing, apply transformations, validate quality, and prepare data for analytics. |
| 🥇 Gold | Build business objects, create dimensions and facts, validate relationships, and document the analytical model. |

---

# 🔗 Data Lineage

Data flows from multiple operational systems through each Medallion layer before reaching the final analytical model.

The following diagram illustrates the complete journey of data from the source systems to the business-ready Gold Layer.

<p align="center">
  <img width="2134" height="1226" alt="image" src="https://github.com/user-attachments/assets/c9b7c01b-0ff8-4e5d-ae60-a257afedbc68" />
</p>

## Benefits of Data Lineage

- End-to-end data traceability.
- Improved transparency across the ETL pipeline.
- Easier debugging and troubleshooting.
- Better data governance and maintainability.
- Clear understanding of data dependencies.

---
# 📂 Source Systems

The Data Warehouse integrates data from two independent operational systems, each contributing different business domains.

## CRM System

The CRM (Customer Relationship Management) system provides operational business data, including:

- `cust_info.csv` — Customer information
- `prd_info.csv` — Current & History Product Infromation
- `sales_details.csv` — Transactional Records about Sales & Orders

## ERP System

The ERP (Enterprise Resource Planning) system provides enterprise reference data, including:

- `CUST_AZ12.csv` — Extra Customer Information (Birthdate)
- `LOC_A101.csv` — Location of Customers (Country)
- `PX_CAT_G1V2.csv` — Product categories 


These source systems are integrated through the ETL pipeline to produce a unified analytical model.

---

# 🥉 Bronze Layer

The Bronze Layer serves as the landing zone for all source data. Data is loaded exactly as received from the source systems without any transformations.

## Purpose

- Preserve raw source data.
- Maintain historical copies of source extracts.
- Enable auditing and traceability.
- Provide a reliable foundation for downstream transformations.

## Processing

- Extract data from CRM and ERP systems.
- Load data into SQL Server.
- Perform a **Full Load** using **TRUNCATE + INSERT**.
- No business logic or data cleansing is applied.

### Key Characteristics

- Raw Data Storage
- Minimal Processing
- High Traceability
- Source-Level Data Preservation

---

# 🥈 Silver Layer

The Silver Layer transforms raw data into clean, standardized, and validated datasets suitable for downstream analytical modeling.

## Purpose

- Improve data quality.
- Standardize formats.
- Resolve inconsistencies.
- Apply business transformation rules.

## Main Transformations

- Data Cleansing
- Duplicate Removal
- NULL Handling
- Standardization
- Data Type Conversion
- Derived Columns
- Business Rule Validation

## Data Quality Rules

The Silver Layer applies multiple quality checks, including:

- Duplicate Detection
- Invalid Date Validation
- Missing Value Handling
- String Standardization
- Consistency Validation

### Key Characteristics

- Clean Data
- Standardized Structure
- Business Rules Applied
- Analytics-Ready Data

---

# 🥇 Gold Layer

The Gold Layer contains business-ready datasets designed specifically for reporting, dashboards, and analytical workloads.

This layer follows a **Dimensional Modeling** approach using a **Star Schema** to simplify analytical queries and improve performance.

### Key Features

- Business-friendly data model
- Optimized for analytics
- Surrogate Keys
- Fact & Dimension relationships
- High Query Performance

The Gold Layer represents the final consumption layer for business intelligence and reporting tools.

---

# 🔄 Integration Model

The integration model illustrates how data from multiple operational systems is consolidated into unified business entities within the Gold Layer.

It defines the relationships between CRM and ERP datasets and demonstrates how customer, product, and sales information are integrated before building the dimensional model.

<p align="center">
    <img width="3290" height="1346" alt="image" src="https://github.com/user-attachments/assets/dcb02801-e21e-4830-bd94-114a1f3feffb" />
</p>

### Integration Highlights

- Integrates CRM and ERP datasets into unified business entities.
- Establishes relationships between operational systems.
- Reduces data redundancy.
- Ensures consistent and reliable analytical data.
- Forms the foundation for the dimensional model.

---

# 🧩 Business Object Mapping 

Before building the dimensional model, source tables are mapped to their corresponding business objects. This mapping defines the business role of each source table and establishes the foundation for the analytical model.

<p align="center">
    <img width="3310" height="1576" alt="image" src="https://github.com/user-attachments/assets/42d43a9b-3966-46c9-a3ec-5078e8f4540d" />
</p>

The mapping process helps to:

- Identify the business purpose of each source table.
- Define ownership and business context.
- Simplify the transformation process.
- Support consistent dimensional modeling.

---

# 🧩 Business Objects

The Gold Layer is built around three core business objects that represent the main business entities used for analytics. Each business object is created by integrating data from the CRM and ERP source systems and applying business transformation rules.

---

## 👤 Customer Business Object

The **Customer** business object integrates customer information from both the CRM and ERP systems to create a single, unified customer dimension.

The transformation process includes:

- Integrating CRM and ERP customer data.
- Applying **LEFT JOIN** operations to combine related datasets.
- Selecting the most relevant business attributes.
- Generating a **Surrogate Key** to uniquely identify each customer.
- Creating a clean and analytics-ready customer dimension.

<p align="center">
    <img width="3212" height="1828" alt="image" src="https://github.com/user-attachments/assets/f78867d9-d7d1-47c2-b217-da4383fcda5d" />
</p>

---

## 📦 Product Business Object

The **Product** business object combines product information with category details collected from multiple source systems.

The transformation process includes:

- Integrating product and category data.
- Applying **LEFT JOIN** operations.
- Standardizing product attributes.
- Creating a **Surrogate Key** for each product.
- Producing a unified product dimension.

<p align="center">
   <img width="3050" height="1830" alt="image" src="https://github.com/user-attachments/assets/4eab7214-326f-4827-af0c-61b9ede8adc7" />
</p>

---

## 💰 Sales Business Object

The **Sales** business object represents the transactional fact table that connects customers and products through surrogate keys.

The transformation process includes:

- Loading sales transactions.
- Linking sales with customer and product dimensions.
- Using generated **Surrogate Keys** instead of business keys.
- Building the final analytical **Fact Table**.

<p align="center">
    <img width="3250" height="998" alt="image" src="https://github.com/user-attachments/assets/502306f2-d8e8-412c-910a-764173837ae5" />
</p>

---
# ⭐ Sales Data Mart (Star Schema)

The final analytical model is implemented as a **Star Schema**, consisting of a central fact table connected to multiple dimension tables.

<p align="center">
    <img width="2300" height="1288" alt="image" src="https://github.com/user-attachments/assets/f1d86cde-4ad6-4851-8004-cfb4713378d4" />
</p>

## Fact Table

- `fact_sales`

## Dimension Tables

- `dim_customers`
- `dim_products`

The Star Schema simplifies analytical queries, improves query performance, and provides an intuitive structure for reporting and business intelligence.

---

## 🛡️ Data Quality

Data Quality is a critical stage within the **Medallion Architecture**, where multiple validation rules are implemented in the **Silver Layer** to ensure that data is accurate, consistent, reliable, and ready for analytical modeling before moving into the **Gold Layer**.

### Data Quality Checks

The implemented data quality checks cover several validation dimensions:

- **Duplicate Detection:** Identify and handle duplicated records.
- **Missing Value Handling:** Manage incomplete or missing attributes.
- **Data Standardization:** Ensure consistent formats and values across datasets.
- **Data Type Validation:** Verify that columns contain the correct data types.
- **Consistency Validation:** Ensure relationships between attributes remain logically correct.
- **Date Validation:** Detect and correct invalid date relationships.

---

## Example: Date Validation and Correction

One of the main data quality challenges identified during the transformation process was handling inconsistent date relationships.

Some records contained date-related issues such as:

- Start dates occurring after end dates.
- Invalid or inconsistent date values.
- Date relationships that could impact analytical accuracy.

To address these issues, validation rules were applied to detect incorrect date relationships, evaluate data consistency, and apply appropriate correction strategies while maintaining data reliability.

The following diagram illustrates the implemented approach for identifying and resolving date-related data quality issues in the Silver Layer before loading the validated data into the Gold Layer.

<p align="center">
<img width="2422" height="1534" alt="image" src="https://github.com/user-attachments/assets/f80d86d5-3d5e-4ffc-af9e-b13d3a7dac7f" />
</p>

---
## 📚 Project Documentation

The project includes comprehensive documentation:

| Document | Description |
|----------|-------------|
| High-Level Architecture | Overall architecture of the Data Warehouse solution. |
| Data Warehouse Implementation Workflow | Implementation lifecycle across Bronze, Silver, and Gold layers. |
| Data Lineage | End-to-end data flow from source systems to analytical models. |
| Integration Model | Integration of CRM and ERP datasets into unified business entities. |
| Business Object Mapping | Maps source tables to business objects. |
| Business Objects | Customer, Product, and Sales transformation logic. |
| Star Schema | Dimensional model of the Sales Data Mart. |
| Data Catalog | Business metadata and column descriptions. |
| Naming Conventions | Standards for naming schemas, tables, columns, and SQL objects. |

---

##  💻 Technologies

| Category | Technology |
|-----------|------------|
| Database | SQL Server |
| Query Tool | SSMS |
| Version Control | Git |
| Repository | GitHub |
| Modeling | Star Schema |
| Documentation | Markdown |
| Diagram Tool | Draw.io |

---

## 📂 Repository Structure

```
Data Warehouse Project
│
├── 📂 datasets
│   ├── 📂 source_crm
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   └── 📂 source_erp
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
│
├── 📂 docs
│   ├── Business_Object_Mapping.png
│   ├── Business_Objects.png
│   ├── Data_Lineage_Diagram.png
│   ├── Data_Warehouse_Architecture.png
│   ├── High_Level_Architecture.png
│   ├── data_catalog.md
│   └── naming_conventions.md
│
├── 📂 scripts
│   ├── init_data_warehouse.sql
│   │
│   ├── 📂 bronze_layer
│   │   ├── bronze_layer_ddl.sql
│   │   └── bronze_layer_proc_load.sql
│   │
│   ├── 📂 silver_layer
│   │   ├── silver_layer_ddl.sql
│   │   └── silver_layer_proc_load.sql
│   │
│   └── 📂 gold_layer
│       └── gold_layer_ddl.sql
│
├── 📂 tests
│   ├── silver_layer_quality_checks.sql
│   └── gold_layer_quality_checks.sql
│
└── 📄 README.md

```

---

## 🦅 Author

  Shatha Khaled ^ـ^ 
