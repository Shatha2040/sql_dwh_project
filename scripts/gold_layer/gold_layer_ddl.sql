/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema).

    Each view transforms and combines data from the Silver layer
    to produce clean, enriched, and business-ready datasets.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================

================================================================================
                     Create Dimension: gold_layer.dim_customers
================================================================================
*/

IF OBJECT_ID('gold_layer.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold_layer.dim_customers;
GO
-- Create Customer Dimension View
CREATE VIEW gold_layer.dim_customers AS

SELECT
    -- Generate surrogate key for each customer
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,

    -- Business key
    ci.cst_id AS customer_id,

    -- Customer information
    ci.cst_key           AS customer_number,
    ci.cst_firstname     AS first_name,
    ci.cst_lastname      AS last_name,
    cl.cntry             AS country,
    ci.cst_marital_status AS marital_status,

    -- Use CRM gender if available; otherwise retrieve it from ERP
    CASE
        WHEN ci.cst_gndr != 'n/a'
            THEN ci.cst_gndr
        ELSE COALESCE(cb.gen, 'n/a')
    END AS gender,

    cb.bdate             AS birthdate,
    ci.cst_create_date   AS create_date

FROM silver_layer.crm_cust_info AS ci

-- Retrieve additional customer information from ERP
LEFT JOIN silver_layer.erp_cust_az12 AS cb
    ON ci.cst_key = cb.cid

LEFT JOIN silver_layer.erp_loc_a101 AS cl
    ON ci.cst_key = cl.cid;

GO


/*
================================================================================
                   Create Dimension: gold_layer.dim_products
================================================================================
*/


IF OBJECT_ID('gold_layer.dim_products', 'V') IS NOT NULL
    DROP VIEW gold_layer.dim_products;
GO

-- Create Product Dimension View
CREATE VIEW gold_layer.dim_products AS

SELECT
    -- Generate surrogate key for each product
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,

    -- Business key
    pn.prd_id AS product_id,

    -- Product information
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date

FROM silver_layer.crm_prd_info AS pn

-- Retrieve category information from ERP
LEFT JOIN silver_layer.erp_px_cat_g1v2 AS pc
    ON pn.cat_id = pc.id

-- Keep only active products
WHERE pn.prd_end_dt IS NULL;

GO

/*
================================================================================
                   Create Fact Table: gold_layer.fact_sales
================================================================================
*/

IF OBJECT_ID('gold_layer.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold_layer.fact_sales;
GO

-- Create Sales Fact View
CREATE VIEW gold_layer.fact_sales AS

SELECT
    -- Order information
    sd.sls_ord_num AS order_number,

    -- Replace business keys with surrogate keys from dimensions
    -- Product Lookup
    dp.product_key AS product_key,

    -- Customer Lookup
    dc.customer_key AS customer_key,

    -- Sales dates
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,

    -- Sales measures
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price

FROM silver_layer.crm_sales_details AS sd

-- Lookup Product Surrogate Key
LEFT JOIN gold_layer.dim_products AS dp
    ON sd.sls_prd_key = dp.product_number

-- Lookup Customer Surrogate Key
LEFT JOIN gold_layer.dim_customers AS dc
    ON sd.sls_cust_id = dc.customer_id;

GO
