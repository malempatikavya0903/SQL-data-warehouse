/*DOL Script:
Create Gold Views
Script Purpose:
This script creates views for the Gold layer in the data warehouse. The Gold layer represents the final dimension and fact tables (Star Schema)
Each view performs transformations and combines data from the Silver layer to produce a clean, enriched, and business-ready dataset.
Usage:
These views can be queried directly for analytics and reporting.*/

/* ============================================================
   GOLD LAYER - CUSTOMER DIMENSION TABLE
   Purpose:
      Combine CRM customer info + ERP extra details + Customer
      location information into a single master customer table.

   Source Tables:
      silver.crm_cust_info         ? CRM customer master
      silver.erp_cust_az12         ? ERP additional customer info
      silver.erp_loc_a101          ? ERP customer country/location

   Join keys:
      cst_key (CRM) = cid (ERP tables)
   ============================================================ */

-- Drop view if it exists
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ------------------------------------------------------------
    -- Generate Surrogate Key for Dimension Table
    ------------------------------------------------------------
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,

    ------------------------------------------------------------
    -- Basic Customer Information (from CRM)
    ------------------------------------------------------------
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    ci.cst_material_status AS marital_status,
                          

    ------------------------------------------------------------
    -- Gender Logic (CRM is master, fallback to ERP)
    ------------------------------------------------------------
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,

    ------------------------------------------------------------
    -- Dates
    ------------------------------------------------------------
    ci.cst_create_date AS create_date,          -- CRM create date
    ca.bdate AS birthdate,                      -- ERP birthdate

    ------------------------------------------------------------
    -- Location Information (from ERP location table)
    ------------------------------------------------------------
    la.cntry AS country

FROM silver.crm_cust_info ci

    ------------------------------------------------------------
    -- Join ERP Customer Table for birthdate + fallback gender
    ------------------------------------------------------------
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid

    ------------------------------------------------------------
    -- Join ERP Location Table for country info
    ------------------------------------------------------------
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;


-- ============================================================
-- View: gold.dim_products
-- Purpose:
--   - Create the Product Dimension for the Gold Layer
--   - Generate a surrogate key using ROW_NUMBER()
--   - Combine CRM product master data with ERP category details
--   - Only active products should be inserted (handled upstream)
-- ============================================================

-- Drop view if it exists

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ------------------------------------------------------------
    -- Surrogate Key for Product Dimension
    -- Ordered by start date and product key for deterministic load
    ------------------------------------------------------------
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,

    ------------------------------------------------------------
    -- Product Master Attributes
    ------------------------------------------------------------
    pn.prd_id AS product_id,           -- Natural product ID
    pn.prd_key AS product_number,      -- Business product key
    pn.prd_nm AS product_name,         -- Product name
    pn.cat_id AS category_id,          -- Category foreign key

    ------------------------------------------------------------
    -- Category Attributes (from ERP)
    ------------------------------------------------------------
    pc.cat AS category,                -- Category name
    pc.subcat AS subcategory,          -- Subcategory
    pc.maintenance,                    -- Maintenance type/category

    ------------------------------------------------------------
    -- Additional Product Details
    ------------------------------------------------------------
    pn.prd_cost AS cost,               -- Product cost
    pn.prd_line AS product_line,       -- Product line
    pn.prd_start_dt AS start_date      -- Product start date

FROM silver.crm_prd_info pn

    -- Join ERP category table to bring category information
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id;

-- ============================================================
-- Fact Sales Joined with Product & Customer Dimensions
-- Purpose:
--   - Bring surrogate keys from Product & Customer dimensions
--   - Prepare clean fact table data for GOLD layer
-- ============================================================

-- Drop view if it exists
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,   -- Sales order number (transaction ID)

    pr.product_key,                   -- Surrogate key from dim_products

    cu.customer_key,                  -- Surrogate key from dim_customers

    sd.sls_order_dt AS order_date,    -- Date when order was created
    sd.sls_ship_dt AS shipping_date,  -- Date when order was shipped
    sd.sls_due_dt AS due_date,        -- Date when order is due

    sd.sls_sales AS sales_amount,     -- Total sales value for the order line
    sd.sls_quantity AS quanity,       -- Quantity sold
    sd.sls_price AS price             -- Unit price of product

FROM silver.crm_sales_details sd

    -- Join to Product Dimension using product business key
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number

    -- Join to Customer Dimension using customer natural key
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
