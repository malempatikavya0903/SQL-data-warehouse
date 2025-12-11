/*Quality Checks
Script Purpose:
This script performs quality checks to validate the integrity, consistency, and accuracy of the Gold Layer. These checks ensure:
Uniqueness of surrogate keys in dimension tables.
Referential integrity between fact and dimension tables.
Validation of relationships in the data model for analytical purposes.
Usage Notes:
Run these checks after data loading Silver Layer.
Investigate and resolve any discrepancies found during the checks.*/


----------------------------------DIMENSIONS QUALITY CHECK FOR CUSTOMERS ------------------------------------------


/* =============================================================
   Quality Check: Duplicate Customer IDs After GOLD Transformation
   Purpose:
      Validate that GOLD Customer table does not contain duplicate
      primary key values (cst_id) after joining CRM + ERP tables.
============================================================== */
SELECT cst_id, COUNT(*) 
FROM (
    SELECT
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
        ci.cst_lastname,
        ci.cst_material_status,   -- included here
        ci.cst_gndr,
        ci.cst_create_date,
        ca.bdate,
        ca.gen,
        la.cntry
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca
        ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 la
        ON ci.cst_key = la.cid
) t 
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


---qulality checks--
SELECT distinct gender FROM gold.dim_customers

SELECT * FROM gold.dim_customers






----------------------------------DIMENSIONS QUALITY CHECK FOR PRODUCT ------------------------------------------
-- =========================================================
-- Data Quality Check: Duplicate prd_key
-- Purpose:
--   - Ensure product_key (prd_key) is unique
--   - Detect if any active product has duplicates
-- =========================================================

SELECT prd_key, COUNT(*) 
FROM (
    SELECT
        pn.prd_id,          -- Product ID
        pn.cat_id,          -- Category ID
        pn.prd_key,         -- Business Product Key (should be unique)
        pn.prd_nm,          -- Product Name
        pn.prd_cost,        -- Product Cost
        pn.prd_line,        -- Product Line
        pn.prd_start_dt,    -- Start Date
        pc.cat,             -- Category Name
        pc.subcat,          -- Subcategory
        pc.maintenance      -- Maintenance Type
    FROM silver.crm_prd_info pn
    LEFT JOIN silver.erp_px_cat_g1v2 pc
        ON pn.cat_id = pc.id
    WHERE pn.prd_end_dt IS NULL   -- Filter out historical (ended) products
) t
GROUP BY prd_key
HAVING COUNT(*) > 1;              -- Return only keys that appear more than once



--quality checks--
SELECT * FROM gold.dim_products 



----------------------------------DIMENSIONS QUALITY CHECK FACT SALES ------------------------------------------
SELECT * FROM gold.fact_sales

-- Foreign Key Integrity Check for Fact Table (fact_sales)
-- This query checks if there are any records in the fact table that do not have matching entries in the dimension tables.
-- Always run this check after loading the fact table to ensure referential integrity.


SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL;
