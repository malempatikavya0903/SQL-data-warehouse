/*
===============================================================================================================
Quality Checks
==============================================================================================================
Script Purpose:
This script performs various quality checks for data consistency, accuracy, and standardization across the 'silver' schemas. It includes checks for:
     -Null or duplicate primary keys.
     -Unwanted spaces in string fields.
     -Data standardization and consistency.
     -Invalid date ranges and orders.
     -Data consistency between related fields.
Usage Notes:
     -Run these checks after data loading Silver Layer.
     -Investigate and resolve any discrepancies found during the checks.
================================================================================================================
*/

/* ============================================
   Silver Layer Quality Check
   Date: 11-12-2025
   Purpose: Validate data quality for 6 Silver tables
=============================================== */

-- 1️ crm_cust_info (Customer Info)
-- Check for NULLs in primary key
SELECT COUNT(*) AS Null_CustID
FROM silver.crm_cust_info
WHERE cust_id IS NULL;

-- Check for duplicate primary keys
SELECT cust_id, COUNT(*) AS DuplicateCount
FROM silver.crm_cust_info
GROUP BY cust_id
HAVING COUNT(*) > 1;

-- Check for missing contact info
SELECT COUNT(*) AS MissingContact
FROM silver.crm_cust_info
WHERE email IS NULL OR phone IS NULL;

--------------------------------------------------
-- 2️. crm_prd_info (Product Info)
SELECT COUNT(*) AS Null_ProductID
FROM silver.crm_prd_info
WHERE prd_id IS NULL;

SELECT prd_id, COUNT(*) AS DuplicateCount
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS InvalidCost
FROM silver.crm_prd_info
WHERE ord_cost <= 0;

--------------------------------------------------
-- 3️.crm_sales_details (Sales Details)
SELECT COUNT(*) AS Null_OrderID
FROM silver.crm_sales_details
WHERE ord_id IS NULL;

SELECT ord_id, COUNT(*) AS DuplicateCount
FROM silver.crm_sales_details
GROUP BY ord_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS InvalidDate
FROM silver.crm_sales_details
WHERE ord_end_dt < ord_start_dt;

--------------------------------------------------
-- 4️.erp_cust_az12 (ERP Customer)
SELECT COUNT(*) AS Null_ERP_CustID
FROM silver.erp_cust_az12
WHERE erp_cust_id IS NULL;

SELECT erp_cust_id, COUNT(*) AS DuplicateCount
FROM silver.erp_cust_az12
GROUP BY erp_cust_id
HAVING COUNT(*) > 1;

--------------------------------------------------
-- 5️5.erp_loc_a101 (Location)
SELECT COUNT(*) AS Null_LocationID
FROM silver.erp_loc_a101
WHERE loc_id IS NULL;

SELECT loc_id, COUNT(*) AS DuplicateCount
FROM silver.erp_loc_a101
GROUP BY loc_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS MissingLocationName
FROM silver.erp_loc_a101
WHERE loc_name IS NULL OR loc_name = '';

--------------------------------------------------
-- 5.erp_px_cat_g1v2 (Product Category)
SELECT COUNT(*) AS Null_CategoryID
FROM silver.erp_px_cat_g1v2
WHERE cat_id IS NULL;

SELECT cat_id, COUNT(*) AS DuplicateCount
FROM silver.erp_px_cat_g1v2
GROUP BY cat_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS MissingCategoryName
FROM silver.erp_px_cat_g1v2
WHERE cat_name IS NULL OR cat_name = '';
