/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/


/******************************************************************************
                                  CRM
******************************************************************************/

/******************************************************************************
                        CRM CUSTOMER INFORMATION
******************************************************************************/

-- CLEAN AND LOAD (CRM_CUST_INFO)

-- QUALITY CHECK: CHECK FOR NULLS OR DUPLICATES IN PRIMARY KEY
-- PRIMARY KEY MUST BE UNIQUE AND NOT NULL

SELECT
    cst_id,
    COUNT(*)
FROM silver_layer.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL;

-- QUALITY CHECK : CHECK FOR UNWANTED SPAES
-- firstname , lastname , cst_lastname

SELECT
    cst_firstname
FROM silver_layer.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- QUALITY CHECK : CHECK THE CONSISTENCY OF VALUE IN LOW CARDINALITYY COLUMNS
-- DATA STANDARDIZATION & CONSISTTENY
--- cst_marital_status

SELECT DISTINCT
    cst_gndr
FROM silver_layer.crm_cust_info;

-- CHECK ALL

SELECT *
FROM silver_layer.crm_cust_info;


/******************************************************************************
                         CRM PRD INFORMATION
******************************************************************************/

SELECT *
FROM silver_layer.crm_prd_info;

-- QUALITY CHECK :CHECK FOR NULLS OR DUPLICATES IN PRIMARY KEY
-- EXPECTATION : No duplicate or NULL values in primary key ^_^

SELECT
    prd_id,
    COUNT(*)
FROM silver_layer.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1
    OR prd_id IS NULL;

-- QUALITY CHECK : CHECK FOR UNWANTED SPAES
-- EXPECTATION : gooogdd ^_^

SELECT
    prd_nm
FROM silver_layer.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- QUALITY CHECK : CHECK FOR NULL OR NEGATIVE NUMBERS
-- EXPECTATION : NO RESULTS

SELECT
    prd_cost
FROM silver_layer.crm_prd_info
WHERE prd_cost < 0
    OR prd_cost IS NULL;

-- QUALITY CHECK : CHECK THE CONSISTENCY OF VALUE IN LOW CARDINALITYY COLUMNS
-- EXPECTATION : NO RESULTS
----- DATA STANDARDIZATION & CONSISTTENY

SELECT DISTINCT
    prd_line
FROM silver_layer.crm_prd_info;

-- QUALITY CHECK :CHECK FOR INVALID DATE ORSERS

SELECT *
FROM silver_layer.crm_prd_info
WHERE prd_end_dt < prd_start_dt; -- END DATA NOT BE EARLIER THAN THE START DATE


/******************************************************************************
                         CRM SALES DETAILSE
******************************************************************************/

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM silver_layer.crm_sales_details;

-- ORDER DATE MUST ALWAYS BE EARLIER THAN THE SHIPPING DATE OR DUE DATE

SELECT *
FROM silver_layer.crm_sales_details
WHERE sls_order_dt > sls_order_dt
    OR sls_order_dt > sls_order_dt;

-- QUALITY CHECK : CHECK DATA CONSISTENY : BETTWEEN SALES , QUANTITY , AND PRICE
-->> BUSINESS RULES
-- S = Q * P
-- Values must not be NULL, zero, or negative.

SELECT DISTINCT

    -- RULES : IF SALES IS NEGATIVE ,ZERO,NULL , DRIVE IT USEING QUANTITY AND PRIE
    -- IF PRICE IS ZERO OR NULL , CALCULLATE IT USING SALES AND QUANTITY.
    -- IF PRICE IS NEGGATIVVE , CONVERT IT TO A POSITTIVE VALUE.

    sls_sales,
    sls_quantity,
    sls_price

FROM silver_layer.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price

-- CHECK NULL
OR sls_sales IS NULL
OR sls_quantity IS NULL
OR sls_price IS NULL

-- CHECK Negative
OR sls_sales <= 0
OR sls_quantity <= 0
OR sls_price <= 0

ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;

SELECT *
FROM silver_layer.crm_sales_details;


/******************************************************************************
                                   ERP
******************************************************************************/

/******************************************************************************
                              ERP CUST AZ12
******************************************************************************/

SELECT *
FROM silver_layer.erp_cust_az12;

-- Quality Check: IDENTIFY OUT-OF-RANGE DATE

SELECT
    bdate
FROM silver_layer.erp_cust_az12
WHERE bdate > GETDATE();

-- Quality Check: DATA STANDARDIZATION & CONSISTENCY
-- RESULT : F, M, NULL, EMPTY STRING

SELECT DISTINCT
    gen
FROM silver_layer.erp_cust_az12;


/******************************************************************************
                               ERP LOC A101
******************************************************************************/

SELECT *
FROM silver_layer.erp_loc_a101;

-- Data Quality Check: The Country column contains NULL values, empty strings,
-- city names instead of country names, abbreviations, and inconsistent country
-- representations (e.g., US, USA, United States). Standardization is required.

SELECT DISTINCT
    cntry
FROM silver_layer.erp_loc_a101
ORDER BY cntry;


/******************************************************************************
                             ERP_PX_CAT_G1V2
******************************************************************************/

-- No data quality issues were found. No transformation is required.

SELECT *
FROM silver_layer.erp_px_cat_g1v2;
