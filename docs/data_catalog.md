# Data Catalog – Gold Layer

## Overview

The **Gold Layer** is the final presentation layer of the Data Warehouse. It contains business-ready data that has been cleansed, standardized, and transformed from the Silver Layer into a dimensional model following the **Star Schema** design.

The purpose of this layer is to provide a reliable and optimized data model for business intelligence (BI), reporting, dashboards, and analytical queries.

The Gold Layer consists of:

- **Dimension Tables** that store descriptive business attributes.
- **Fact Tables** that store measurable business events.
- **Surrogate Keys** used to establish relationships between fact and dimension tables for improved query performance and data consistency.

---
## Gold Layer Star Schema

<img width="1280" height="857" alt="image" src="https://github.com/user-attachments/assets/e595c27e-ca7a-4d60-91ea-9e973837d404" />

**Figure 1:** Star Schema for the Gold Layer. The **fact_sales** table is located at the center and is connected to the **dim_customers** and **dim_products** dimension tables using surrogate keys through one-to-many relationships.


# 1. gold_layer.dim_customers

## Purpose

The **Customer Dimension** stores descriptive information about customers. It provides demographic and geographic attributes that allow analysts to study customer behavior and segment sales based on customer characteristics.

### Table Information

| Property | Value |
|----------|-------|
| Table Name | gold_layer.dim_customers |
| Table Type | Dimension |
| Primary Key | customer_key |
| Grain | One row represents one customer |

---

## Columns

| Column Name | Data Type | Key Type | Description |
|-------------|-----------|----------|-------------|
| **customer_key** | INT | Primary Key (Surrogate Key) | A system-generated surrogate key that uniquely identifies each customer record within the data warehouse. It is used to establish relationships with the fact table and has no business meaning. |
| **customer_id** | INT | Business Key | The original customer identifier obtained from the CRM source system. It uniquely identifies a customer in the operational system. |
| **customer_number** | NVARCHAR(50) | Business Attribute | A business reference number assigned to the customer for operational tracking and identification purposes. |
| **first_name** | NVARCHAR(50) | Business Attribute | The customer's first name. |
| **last_name** | NVARCHAR(50) | Business Attribute | The customer's family or last name. |
| **country** | NVARCHAR(50) | Business Attribute | The country where the customer resides after data standardization. |
| **marital_status** | NVARCHAR(50) | Business Attribute | The customer's marital status after cleansing and standardization (e.g., Married, Single). |
| **gender** | NVARCHAR(50) | Business Attribute | The customer's gender after mapping inconsistent source values into standardized values. |
| **birthdate** | DATE | Business Attribute | The customer's date of birth. Used for age and demographic analysis. |
| **create_date** | DATE | Business Attribute | The date when the customer record was originally created in the source system. |

---

## Business Notes

- Each customer appears only once in this dimension.
- The table uses a **Surrogate Key** instead of the business key for joining with the fact table.
- Customer attributes have been standardized during the ETL process.
- This dimension supports customer segmentation and demographic analysis.

### Example Business Questions

- Which country generates the highest revenue?
- Which customer segment purchases the most products?
- What is the sales distribution by gender?
- How do purchasing behaviors vary across different age groups?

---

# 2. gold_layer.dim_products

## Purpose

The **Product Dimension** contains descriptive information about products, including product hierarchy, categories, product lines, maintenance requirements, and pricing attributes. It enables detailed product-based sales analysis.

### Table Information

| Property | Value |
|----------|-------|
| Table Name | gold_layer.dim_products |
| Table Type | Dimension |
| Primary Key | product_key |
| Grain | One row represents one product |

---

## Columns

| Column Name | Data Type | Key Type | Description |
|-------------|-----------|----------|-------------|
| **product_key** | INT | Primary Key (Surrogate Key) | A warehouse-generated surrogate key uniquely identifying each product record. Used as the foreign key in the fact table. |
| **product_id** | INT | Business Key | Original product identifier from the CRM system. |
| **product_number** | NVARCHAR(50) | Business Attribute | Business product code used for inventory management and operational tracking. |
| **product_name** | NVARCHAR(50) | Business Attribute | Descriptive product name including details such as model, size, or color. |
| **category_id** | NVARCHAR(50) | Business Attribute | Identifier representing the product's main category. |
| **category** | NVARCHAR(50) | Business Attribute | High-level product category such as Bikes, Components, Clothing, or Accessories. |
| **subcategory** | NVARCHAR(50) | Business Attribute | Detailed classification of the product within its category. |
| **maintenance_required** | NVARCHAR(50) | Business Attribute | Indicates whether the product requires regular maintenance (Yes or No). |
| **cost** | INT | Measure Attribute | Standard manufacturing or purchasing cost of the product. |
| **product_line** | NVARCHAR(50) | Business Attribute | Product line or collection to which the product belongs (e.g., Road, Mountain, Touring). |
| **start_date** | DATE | Business Attribute | Date when the product became active or available for sale. |

---

## Business Notes

- Only active products are included in this dimension.
- Product hierarchy has been standardized during ETL.
- The surrogate key ensures stable relationships even if business identifiers change.
- The table supports category-based and product-level reporting.

### Example Business Questions

- Which product category generates the highest sales?
- Which products require maintenance?
- Which product line is the most profitable?
- What are the total sales by product category?

---

# 3. gold_layer.fact_sales

## Purpose

The **Sales Fact Table** stores transactional sales records and serves as the central table in the Star Schema. It contains measurable business metrics and references dimension tables through surrogate keys.

Each record represents **one product sold within one sales order (one order line).**

### Table Information

| Property | Value |
|----------|-------|
| Table Name | gold_layer.fact_sales |
| Table Type | Fact |
| Grain | One sales order line |
| Foreign Keys | customer_key, product_key |
| Measures | sales_amount, quantity, price |

---

## Columns

| Column Name | Data Type | Type | Description |
|-------------|-----------|------|-------------|
| **order_number** | NVARCHAR(50) | Degenerate Dimension | Unique identifier for the sales order. Stored directly in the fact table because it does not require a separate dimension table. |
| **product_key** | INT | Foreign Key | Surrogate key referencing **gold_layer.dim_products**. |
| **customer_key** | INT | Foreign Key | Surrogate key referencing **gold_layer.dim_customers**. |
| **order_date** | DATE | Date Attribute | Date when the customer placed the order. |
| **shipping_date** | DATE | Date Attribute | Date when the order was shipped. |
| **due_date** | DATE | Date Attribute | Payment due date associated with the order. |
| **sales_amount** | INT | Measure | Total sales amount for the order line. |
| **quantity** | INT | Measure | Number of product units sold. |
| **price** | INT | Measure | Selling price per unit of the product. |

---

## Business Notes

- The fact table contains only measurable business events.
- Foreign keys link each sales transaction to the related customer and product dimensions.
- Surrogate keys improve join performance and maintain referential integrity.
- The table is optimized for aggregation and reporting.

### Example Business Questions

- What are the total sales over time?
- Which customers generate the highest revenue?
- Which products sell the most units?
- What is the average selling price by category?
- What are the monthly sales trends?
- Which countries contribute the highest sales revenue?

---

# Relationships

| Source Table | Key | Target Table | Relationship |
|--------------|-----|--------------|--------------|
| gold_layer.fact_sales | customer_key | gold_layer.dim_customers | Many-to-One |
| gold_layer.fact_sales | product_key | gold_layer.dim_products | Many-to-One |

---

# Star Schema Summary

| Table | Type | Description |
|-------|------|-------------|
| **gold_layer.dim_customers** | Dimension | Stores descriptive customer information used for customer analysis. |
| **gold_layer.dim_products** | Dimension | Stores descriptive product information used for product analysis. |
| **gold_layer.fact_sales** | Fact | Stores transactional sales data and business measures linked to customer and product dimensions. |

---

## Data Model Notes

- The Gold Layer follows the **Star Schema** design.
- All joins between the fact table and dimension tables are performed using **Surrogate Keys**.
- Dimension tables contain descriptive business attributes.
- The fact table contains measurable metrics used for reporting and analytics.
- This layer is optimized for BI tools such as **Power BI**, **Tableau**, and other analytical platforms.
