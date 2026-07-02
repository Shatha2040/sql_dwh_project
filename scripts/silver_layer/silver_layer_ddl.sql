/*
===============================================================================
DDL Script: Create 'silver_layer' Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver_layer' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze_layer' Tables
===============================================================================
*/

--Create Tables (CRM) 
--crm_cust_info
-- Check if the table exists in the silver layer, and drop it before recreating to avoid duplication errors
IF OBJECT_ID('silver_layer.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE  silver_layer.crm_cust_info;
GO
CREATE TABLE silver_layer.crm_cust_info(

	cst_id             INT,
	cst_key            NVARCHAR(50) ,
	cst_firstname      NVARCHAR(50),
	cst_lastname       NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr           NVARCHAR(50),
	cst_create_date    DATE ,
	--Added column (not present in source system)
	-- Automatically records the timestamp when the record is loaded into the Data Warehouse
	dwh_create_data DATETIME2 DEFAULT GETDATE()
);
GO
--crm_prd_info
IF OBJECT_ID('silver_layer.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver_layer.crm_prd_info;
GO
CREATE TABLE silver_layer.crm_prd_info(

	prd_id       INT,
	cat_id       NVARCHAR(50),
	prd_key      NVARCHAR(50),
	prd_nm       NVARCHAR(50),
	prd_cost     INT,
	prd_line     NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt   DATE,
	--Added column (not present in source system)
	-- Automatically records the timestamp when the record is loaded into the Data Warehouse
	dwh_create_data DATETIME2 DEFAULT GETDATE()
);
GO
--crm_sales_details
IF OBJECT_ID('silver_layer.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver_layer.crm_sales_details ;
GO
CREATE TABLE silver_layer.crm_sales_details(

	sls_ord_num	 NVARCHAR(50),
	sls_prd_key	 NVARCHAR(50) ,
	sls_cust_id  INT,
	sls_order_dt DATE,
	sls_ship_dt  DATE,
	sls_due_dt   DATE,
	sls_sales    INT,
	sls_quantity INT,
	sls_price    INT,
	--Added column (not present in source system)
	-- Automatically records the timestamp when the record is loaded into the Data Warehouse
	dwh_create_data DATETIME2 DEFAULT GETDATE()
);
GO
--Create Tables (ERP) 
--erp_loc_a101
IF OBJECT_ID('silver_layer.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver_layer.erp_loc_a101;
GO
CREATE TABLE silver_layer.erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(50),
	--Added column (not present in source system)
	-- Automatically records the timestamp when the record is loaded into the Data Warehouse
	dwh_create_data DATETIME2 DEFAULT GETDATE()
);
GO
--erp_cust_az12
IF OBJECT_ID('silver_layer.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver_layer.erp_cust_az12;
GO
CREATE TABLE silver_layer.erp_cust_az12 (

    cid    NVARCHAR(50),
    bdate  DATE,
    gen    NVARCHAR(50),
	--Added column (not present in source system)
	-- Automatically records the timestamp when the record is loaded into the Data Warehouse
	dwh_create_data DATETIME2 DEFAULT GETDATE()
);
GO
--erp_px_cat_g1v2
IF OBJECT_ID('silver_layer.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver_layer.erp_px_cat_g1v2;
GO
CREATE TABLE silver_layer.erp_px_cat_g1v2 (

    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50),
	--Added column (not present in source system)
	-- Automatically records the timestamp when the record is loaded into the Data Warehouse
	dwh_create_data DATETIME2 DEFAULT GETDATE()
);
GO
