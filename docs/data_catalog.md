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

<img width="2288" height="1376" alt="image" src="https://github.com/user-attachments/assets/ee96b2a9-1826-44d2-88e7-d9fff8d4451a" />

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


| Column Name | Data Type | Key Type | Description | Example |
|-------------|-----------|----------|-------------|---------|
| customer_key | INT | Primary Key (Surrogate Key) | Surrogate key uniquely identifying each customer record in the dimension table. | - |
| customer_id | INT | Business Key | Unique numerical identifier assigned to each customer. | 11000 |
| customer_number | NVARCHAR(50) | Business Attribute | Alphanumeric identifier representing the customer, used for tracking and referencing. | AW00011000 |
| first_name | NVARCHAR(50) | Attribute | The customer's first name, as recorded in the system. | John |
| last_name | NVARCHAR(50) | Attribute | The customer's last name or family name. | Smith |
| country | NVARCHAR(50) | Attribute | The country of residence for the customer (e.g., 'Australia'). | Australia |
| marital_status | NVARCHAR(50) | Attribute | The marital status of the customer (e.g., 'Married', 'Single'). | Married |
| gender | NVARCHAR(50) | Attribute | The gender of the customer (e.g., 'Male', 'Female', 'n/a'). | Female |
| birthdate | DATE | Date Attribute | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06). | 1971-10-06 |
| create_date | DATE | Date Attribute | The date and time when the customer record was created in the system. | 2012-03-25 |



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

| Column Name | Data Type | Key Type | Description | Example |
|-------------|-----------|----------|-------------|---------|
| product_key | INT | Primary Key (Surrogate Key) | Surrogate key uniquely identifying each product record in the product dimension table. | - |
| product_id | INT | Business Key | A unique identifier assigned to the product for internal tracking and referencing. | 310 |
| product_number | NVARCHAR(50) | Business Attribute | A structured alphanumeric code representing the product, often used for categorization or inventory. | BK-M82B-42 |
| product_name | NVARCHAR(50) | Attribute | Descriptive name of the product, including key details such as type, color, and size. | Mountain Bike Black 42 |
| category_id | NVARCHAR(50) | Business Attribute | A unique identifier for the product's category, linking to its high-level classification. | BI |
| category | NVARCHAR(50) | Attribute | The broader classification of the product (e.g., Bikes, Components) to group related items. | Bikes |
| subcategory | NVARCHAR(50) | Attribute | A more detailed classification of the product within the category, such as product type. | Mountain Bikes |
| maintenance_required | NVARCHAR(50) | Attribute | Indicates whether the product requires maintenance (e.g., 'Yes', 'No'). | Yes |
| cost | INT | Measure Attribute | The cost or base price of the product, measured in monetary units. | 1250 |
| product_line | NVARCHAR(50) | Attribute | The specific product line or series to which the product belongs (e.g., Road, Mountain). | Mountain |
| start_date | DATE | Date Attribute | The date when the product became available for sale or use. | 2013-01-01 |

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

| Column Name | Data Type | Key Type | Description | Example |
|-------------|-----------|----------|-------------|---------|
| order_number | NVARCHAR(50) | Degenerate Dimension | A unique alphanumeric identifier for each sales order (e.g., 'SO54496'). | SO54496 |
| product_key | INT | Foreign Key | Surrogate key linking the order to the product dimension table. | - |
| customer_key | INT | Foreign Key | Surrogate key linking the order to the customer dimension table. | - |
| order_date | DATE | Date Attribute | The date when the order was placed. | 2013-05-15 |
| shipping_date | DATE | Date Attribute | The date when the order was shipped to the customer. | 2013-05-17 |
| due_date | DATE | Date Attribute | The date when the order payment was due. | 2013-06-14 |
| sales_amount | INT | Measure | The total monetary value of the sale for the line item, in whole currency units (e.g., 25). | 25 |
| quantity | INT | Measure | The number of units of the product ordered for the line item (e.g., 1). | 1 |
| price | INT | Measure | The price per unit of the product for the line item, in whole currency units (e.g., 25). | 25 |

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
