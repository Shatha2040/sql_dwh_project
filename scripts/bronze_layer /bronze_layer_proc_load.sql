/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze_layer.load_bronze;
===============================================================================
*/

--Create Stored Procedure =============================================================

CREATE OR ALTER PROCEDURE bronze_layer.load_bronze AS 

BEGIN

    DECLARE @start_time DATETIME , @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;  ; 

    BEGIN TRY

	        SET @batch_start_time = GETDATE();
			PRINT '************************************************************************************';
			PRINT 'Loding Bronze Layer';
			PRINT '************************************************************************************';


			--======================================================================
		                            	--Load data (CRM) 
			--======================================================================

			PRINT '------------------------------------------------------------------------------------';
			PRINT 'Loding (CRM) Tables'
			PRINT '------------------------------------------------------------------------------------';

			--Truncate Table (1)=========================================================================

			SET @start_time =GETDATE();
			PRINT '>>>> Truncating Table(1):  bronze_layer.crm_cust_info';
			TRUNCATE TABLE bronze_layer.crm_cust_info;


			--Inser data ===============================================================================

			PRINT '>>>> Inserting Data Into : bronze_layer.crm_cust_info ';
			BULK INSERT bronze_layer.crm_cust_info
			FROM 'C:\Users\shatha khaled\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
			WITH (

				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 

			);
			SET @end_time =GETDATE();
			PRINT '>>>>(1) Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		    PRINT '-------------';


			--Truncate Table (2)==============================================================

			SET @start_time =GETDATE();
			PRINT '>>>> Truncating Table(2) : bronze_layer.crm_prd_info ';
			TRUNCATE TABLE bronze_layer.crm_prd_info;

			--Inser data ===============================================================================

			PRINT '>>>> Inserting Data Into : bronze_layer.crm_prd_info ';
			BULK INSERT bronze_layer.crm_prd_info
			FROM 'C:\Users\shatha khaled\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
			WITH (

				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 

			);
			SET @end_time =GETDATE();
			PRINT '>>>>(2) Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		    PRINT ' -------------';


			--Truncate Table (3) =========================================================================

			SET @start_time =GETDATE();
			PRINT '>>>> Truncating Table(3) : bronze_layer.crm_sales_details ';
			TRUNCATE TABLE bronze_layer.crm_sales_details;

			--Inser data ===============================================================================

			PRINT '>>>> Inserting Data Into : bronze_layer.crm_sales_details ';

			BULK INSERT bronze_layer.crm_sales_details
			FROM 'C:\Users\shatha khaled\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
			WITH (

				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 

			);

			SET @end_time =GETDATE();
			PRINT '>>>>(3) Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		    PRINT ' -------------';

			--======================================================================
		                            	--Load data (ERP) 
			--======================================================================

			PRINT '------------------------------------------------------------------------------------';
			PRINT 'Loding  (ERP) Tables'
			PRINT '------------------------------------------------------------------------------------';


			--Truncate Table (1) =========================================================================

			SET @start_time =GETDATE();
			PRINT '>>>> Truncating Table(1) : bronze_layer.erp_cust_az12 ';
			TRUNCATE TABLE bronze_layer.erp_cust_az12;

			--Inser data ===============================================================================

			PRINT '>>>> Inserting Data Into : bronze_layer.erp_cust_az12 ';
			BULK INSERT bronze_layer.erp_cust_az12
			FROM 'C:\Users\shatha khaled\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
			WITH (

				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 

			);

			SET @end_time =GETDATE();
			PRINT '>>>>(1) Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		    PRINT '-------------';


			--Truncate Table (2) =========================================================================

			SET @start_time =GETDATE();
			PRINT '>>>> Truncating Table(2) : bronze_layer.erp_loc_a101';
			TRUNCATE TABLE bronze_layer.erp_loc_a101;

			--Inser data ===============================================================================

			PRINT '>>>> Inserting Data Into : bronze_layer.erp_loc_a101 ';
			BULK INSERT bronze_layer.erp_loc_a101
			FROM 'C:\Users\shatha khaled\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
			WITH (

				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 

			);

			SET @end_time =GETDATE();
			PRINT '>>>>(2) Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		    PRINT '-------------';

			--Truncate Table (3) =========================================================================

			SET @start_time =GETDATE();
			PRINT '>>>> Truncating Table(3) : bronze_layer.erp_px_cat_g1v2';
			TRUNCATE TABLE bronze_layer.erp_px_cat_g1v2;

			--Inser data ===============================================================================

			PRINT '>>>> Inserting Data Into : bronze_layer.erp_px_cat_g1v2 ';
			BULK INSERT bronze_layer.erp_px_cat_g1v2
			FROM 'C:\Users\shatha khaled\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
			WITH (

				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 

			);

			SET @end_time =GETDATE();
			PRINT '>>>>(3) Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		    PRINT ' -------------';


			SET @batch_end_time = GETDATE();
			PRINT '*******************************************'
			PRINT 'Loading Bronze Layer is Completed';
			PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
			PRINT '*******************************************'

		END TRY
		BEGIN CATCH

		    PRINT '************************************************************************************';
			PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
			PRINT 'Error Message' + ERROR_MESSAGE();
			PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
			PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
			PRINT '************************************************************************************';

		END CATCH

END
