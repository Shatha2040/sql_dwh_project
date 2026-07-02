/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver_layer.load_silver;
===============================================================================


*********************************************************************************
                                 CRM
*********************************************************************************
================================================================================
                     LOAD DATA INTO SILVER LAYER(CRM_CUST_INFO)
================================================================================
*/
CREATE OR ALTER PROCEDURE silver_layer.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY

        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------'
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver_layer.crm_cust_info';
        TRUNCATE TABLE silver_layer.crm_cust_info;
        PRINT '>> Inserting Data Into: silver_layer.crm_cust_info';
        INSERT INTO silver_layer.crm_cust_info(
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_date
        )
        /*
        ================================================================================
                        DATA TRANSFORMATION (BRONZE → SILVER) (CRM_CUST_INFO)
        ================================================================================
        */
        SELECT 
        cst_id,
        cst_key,
        --- REMOVE UNWANTED SPAES ---
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname ,
        --- DATA NORMALIZATION & STANDARDIZATTION ---
        CASE WHEN UPPER(TRIM( cst_marital_status)) = 'S' THEN 'Single'
             WHEN UPPER( TRIM( cst_marital_status )) = 'M' THEN 'Married'
            -- HANDLING MISSING VALUE
             ELSE 'n/a' 
        END cst_marital_status ,

        CASE WHEN UPPER(TRIM( cst_gndr )) = 'F' THEN 'Female'
             WHEN UPPER( TRIM(cst_gndr )) = 'M' THEN 'Male'
             --
             ELSE 'n/a'
        END cst_gndr,
        ---
        cst_create_date
        -- REMOVE DUPLICATE
        FROM
        (
        SELECT *, 
        ROW_NUMBER () OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last 
        FROM bronze_layer.crm_cust_info
        WHERE cst_id IS NOT NULL
        )t WHERE flag_last = 1 -- DATA FILTERING
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        /*
        ================================================================================
                    LOAD DATA INTO SILVER LAYER ( CRM PRD INFORMATION)
        ================================================================================
        */
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver_layer.crm_prd_info';
        TRUNCATE TABLE silver_layer.crm_prd_info;
        PRINT '>> Inserting Data Into: silver_layer.crm_prd_info';
        INSERT INTO silver_layer.crm_prd_info (
	        prd_id,
	        cat_id,
	        prd_key,
	        prd_nm,
	        prd_cost,
	        prd_line,
	        prd_start_dt,
	        prd_end_dt
        )
        /*
        ================================================================================
                  DATA TRANSFORMATION (BRONZE → SILVER)  CRM PRD INFORMATION
        ================================================================================
        */
        SELECT 
            prd_id,
           --- Extract category ID ---
           -- SELECT distinct id from bronze_layer.erp_px_cat_g1v2 --> AC_BC
            REPLACE( SUBSTRING(prd_key,1 ,5), '-','_') AS cat_id,
           ---
           --- Extract product key ---
            SUBSTRING(prd_key,7 ,LEN(prd_key)) AS prd_key,
           ---
            prd_nm,
            ISNULL(prd_cost,0) AS prd_cost ,
            --- Map product line codes to descriptive values ---
            -- QUICK CASE WHEN IDEAL FOR SIMPLE VALUE MAPPING ---
            CASE UPPER(TRIM(prd_line))
				        WHEN  'M' THEN 'Mountain'
				        WHEN  'R' THEN 'Road'
				        WHEN  'S' THEN 'Other Sales'
				        WHEN  'T' THEN 'Touring'
				        ELSE 'n/a'
	        END AS prd_line,
            ---
            CAST(prd_start_dt AS DATE ) AS prd_start_dt,
            --- LEAD(): ACCESS VALUE FROM NEXT ROW WITHIN A WINDOW --
            CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
        FROM bronze_layer.crm_prd_info
        -- FILTERS OUT UNMATCHED DATA AFTER APPLAY TRANSFORMATION 
        -- WHERE REPLACE( SUBSTRING(prd_key,1 ,5), '-','_') NOT IN (SELECT distinct id from bronze_layer.erp_px_cat_g1v2) --RESULTS (CO_PE)
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';  
        /*
        ================================================================================
                       LOAD DATA INTO SILVER LAYER ( CRM SALES DETAILSE)
        ================================================================================
        */
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver_layer.crm_sales_details';
        TRUNCATE TABLE silver_layer.crm_sales_details;
        PRINT '>> Inserting Data Into: silver_layer.crm_sales_details';
        INSERT INTO silver_layer.crm_sales_details(
	        sls_ord_num,
	        sls_prd_key,
	        sls_cust_id,
	        sls_order_dt,
	        sls_ship_dt,
	        sls_due_dt,
	        sls_sales,
	        sls_quantity,
	        sls_price    
        )
        /*
        ================================================================================
                DATA TRANSFORMATION (BRONZE → SILVER)  CRM SALES DETAILSE
        ================================================================================
        */
        SELECT 
			        sls_ord_num,
			        sls_prd_key,
			        sls_cust_id,
		            -- Data Type Conversion: SQL Server cannot directly convert an integer
                    -- value to DATE. The value must first be converted to VARCHAR,
                    -- then converted to DATE.
                    CASE
                     WHEN sls_order_dt = 0 OR LEN(sls_order_dt) !=8 THEN NULL
                     ELSE CAST(CAST(sls_order_dt AS VARCHAR)AS DATE)
                    END AS sls_order_dt,

                    CASE
                     WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) !=8 THEN NULL
                     ELSE CAST(CAST(sls_ship_dt AS VARCHAR)AS DATE)
                    END AS sls_ship_dt, 

                    CASE
                     WHEN sls_due_dt = 0 OR LEN(sls_due_dt) !=8 THEN NULL
                     ELSE CAST(CAST(sls_due_dt AS VARCHAR)AS DATE)
                    END AS sls_due_dt,
                    -- RULES : IF SALES IS NEGATIVE ,ZERO,NULL , DRIVE IT USEING QUANTITY AND PRIE 
                    -- IF PRICE IS ZERO OR NULL , CALCULLATE IT USING SALES AND QUANTITY .
                    -- IF PRICE IS NEGGATIVVE , CONVERT IT TO A POSITTIVE VALUE .
                    CASE WHEN sls_sales IS NULL  OR sls_sales <=0 OR sls_sales != sls_quantity* ABS(sls_price)
                              THEN sls_quantity* ABS(sls_price)
                         ELSE sls_sales
                    END AS sls_sales, 
                    sls_quantity
			        CASE WHEN sls_price IS NULL OR sls_price <=0 
			                -- Defensive programming: Use NULLIF() to handle any potential zero values
					        -- and prevent division-by-zero errors, even if none currently exist.
					        THEN sls_sales / NULLIF( sls_quantity , 0) 
				        ELSE sls_price
		            END AS sls_price
        FROM bronze_layer.crm_sales_details
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        /*

        *********************************************************************************
                                            ERP
        *********************************************************************************
         */
        PRINT '------------------------------------------------';
    		PRINT 'Loading ERP Tables';
    		PRINT '------------------------------------------------';
         /*
        ================================================================================
                       LOAD DATA INTO SILVER LAYER (ERP CUST AZ12)
        ================================================================================
        */
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver_layer.erp_cust_az12';
        TRUNCATE TABLE silver_layer.erp_cust_az12;
        PRINT '>> Inserting Data Into: silver_layer.erp_cust_az12';
        INSERT INTO silver_layer.erp_cust_az12(
	        cid,
          bdate,
          gen  
        )

        /*
        ================================================================================
                DATA TRANSFORMATION (BRONZE → SILVER)   ERP CUST AZ12
        ================================================================================
        */
        SELECT
            CASE
                WHEN cid LIKE 'NAS%'
                    THEN SUBSTRING(cid, 4, LEN(cid))
                ELSE cid
            END AS cid,
            CASE 
                WHEN bdate > GETDATE() 
                     THEN NULL
                ELSE bdate
            END AS bdate,
            CASE 
               WHEN UPPER(TRIM(gen)) IN ( 'F' , 'FEMALE') 
                    THEN 'Female'
 
               WHEN UPPER(TRIM(gen)) IN ( 'M' , 'MALE') 
                    THEN 'Male'
               ELSE 'n/a'
            END AS gen 
        FROM bronze_layer.erp_cust_az12
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        /*
        ================================================================================
                       LOAD DATA INTO SILVER LAYER (ERP LOC A101)
        ================================================================================
        */
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver_layer.erp_loc_a101';
        TRUNCATE TABLE silver_layer.erp_loc_a101;
        PRINT '>> Inserting Data Into: silver_layer.erp_loc_a101';
        INSERT INTO silver_layer.erp_loc_a101(
	        cid,
          cntry  
        )
        /*
        ================================================================================
                   DATA TRANSFORMATION (BRONZE → SILVER)   ERP LOC A101
        ================================================================================
        */
        SELECT 
         REPLACE(cid, '-','') cid ,
          CASE
		        WHEN TRIM(cntry) = 'DE' 
                     THEN 'Germany'
		        WHEN TRIM(cntry) IN ('US', 'USA')
                     THEN 'United States'
		        WHEN TRIM(cntry) = '' OR cntry IS NULL 
                     THEN 'n/a'
		        ELSE TRIM(cntry)
          END AS cntry -- Normalize and Handle missing or blank country codes
        FROM bronze_layer.erp_loc_a101
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------'; 
         /*
        ================================================================================
                       LOAD DATA INTO SILVER LAYER (ERP_PX_CAT_G1V2)
        ================================================================================
        */
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver_layer.erp_px_cat_g1v2';
        TRUNCATE TABLE silver_layer.erp_px_cat_g1v2;
        PRINT '>> Inserting Data Into: silver_layer.erp_px_cat_g1v2';
        INSERT INTO silver_layer.erp_px_cat_g1v2 (
            id,
            cat,
            subcat,
            maintenance
        )
         /*
        ================================================================================
               DATA TRANSFORMATION (BRONZE → SILVER)    ERP_PX_CAT_G1V2
        ================================================================================
        */
        -- No data quality issues were found. No transformation is required.
        SELECT
            id,
            cat,
            subcat,
            maintenance
        FROM bronze_layer.erp_px_cat_g1v2 
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';  

        SET @batch_end_time = GETDATE();
    		PRINT '=========================================='
    		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
    		PRINT '=========================================='

    END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
