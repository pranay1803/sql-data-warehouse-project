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
    EXEC bronze.load_bronze;
===============================================================================
*/

USE Datawarehouse;
GO 
CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
    BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @start_batch_time DATETIME, @start_batch_time
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        SET @start_time = GETDATE()
        print '===================================================';
        PRINT 'Loading bronze layer';
        PRINT '===================================================';
        PRINT '---------------------------------------------------';
        PRINT 'Loading the crm table';
        PRINT '---------------------------------------------------';
       
        PRINT '>> Truncating table: Bronze.crm_cust_info ';
        TRUNCATE table Bronze.crm_cust_info
        PRINT '>> Instering data into: Bronze.crm_cust_info';
        BULK INSERT Bronze.crm_cust_info
        FROM '/var/opt/mssql/data/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK

        );
        SET @end_time = GETDATE();
        PRINT '>>Loading duration:' + CAST( DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
        SET @start_time = GETDATE();
        PRINT '>> Truncating table:Bronze.crm_prd_info ';
        TRUNCATE table Bronze.crm_prd_info
        PRINT '>> Inserting table:Bronze.crm_prd_info ';
        BULK INSERT Bronze.crm_prd_info
        FROM '/var/opt/mssql/data/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
         SET @end_time = GETDATE();
         PRINT '>>Loading duration:' + CAST( DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
        SET @start_time = GETDATE();
        PRINT '>> Truncating table:Bronze.crm_sales_details ';
        TRUNCATE table Bronze.crm_sales_details
        PRINT '>> Instering table:Bronze.crm_sales_details ';
        BULK INSERT Bronze.crm_sales_details
        FROM '/var/opt/mssql/data/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
         SET @end_time = GETDATE();
         PRINT '>>Loading duration:' + CAST( DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
          PRINT '---------------------------------------------------';
        PRINT 'Loading the erp table';
        PRINT '---------------------------------------------------';
        SET @start_time = GETDATE();
        PRINT '>> Truncating table:Bronze.erp_cust_az12 ';
        TRUNCATE table Bronze.erp_cust_az12
        PRINT '>> Inserting table:Bronze.erp_cust_az12 ';
        BULK INSERT Bronze.erp_cust_az12
        FROM '/var/opt/mssql/data/CUST_AZ12.csv'
        WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
         SET @end_time = GETDATE();
         PRINT '>>Loading duration:' + CAST( DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
        SET @start_time = GETDATE();
        PRINT '>> Truncating table:Bronze.Loc_A101';
        TRUNCATE table Bronze.erp_loc
        PRINT '>> Inserting table:Bronze.LOC_A101 ';
        BULK INSERT Bronze.erp_loc
        FROM '/var/opt/mssql/data/LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>>Loading duration:' + CAST( DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
        SET @start_time = GETDATE();
         PRINT '>> Truncating table:Bronze.PX_CAT_G1V21';
        TRUNCATE table Bronze.erp_px_cat
         PRINT '>> Inserting table:Bronze.PX_CAT_G1V2';
        BULK INSERT Bronze.erp_px_cat
        FROM '/var/opt/mssql/data/PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT '>>Loading duration:' + CAST( DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
        SET @end_batch_time = GETDATE()
        SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
    END TRY
    BEGIN CATCH
        PRINT '========================================'
        PRINT 'ERROR OCCURED DURING LOADING THE BRONZE LAYER'
        PRINT 'ERROR MESSAGE' + ERROR_MESSAGE()
        PRINT 'ERROR MESSAGE' + CAST( ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR MESSAGE' + CAST( ERROR_STATE() AS NVARCHAR);
    END CATCH

    END

