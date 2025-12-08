-- Quality Checks

-- Script Purpose:

--This script performs various quality checks for data consistency, accuracy and standardization across the 'silver' schemas. It includes checks for:
--Null or duplicate primary keys.
--Unwanted spaces in string fields.
--Data standardization and consistency.
--Invalid date ranges and orders.
--Data consistency between related fields.

-- Usage Notes:
--Run these checks after data loading Silver Layer.
-- Investigate and resolve any discrepancies found durPthe checks.



-- check for Nulls or Duplicates in primary key
-- Expectation: No Result

SELECT
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL

SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL

-- check for unwanted scpaes 
-- Expectation: No Result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm) 

-- check for NULLS or Negative Numbers 
-- Expectations: No Results

SELECT prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 or prd_cost IS NULL


-- data standardization and consistency 
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- CHECK FOR invalid Date Orders 
SELECT *
FROM silver.crm_prd_info 
WHERE prd_end_dt < prd_start_dt

SELECT *
FROM silver.crm_prd_info

SELECT 
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
or LEN(sls_order_dt) != 8 
or sls_order_dt > 20500101
or sls_order_dt < 19010101

SELECT 
*
FROM bronze.crm_sales_details 
WHERE sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt

-- check data conssistency : between sales, quantity, price 
-- sales = quan x price 
-- vales must not be NULL, Zero or Negative 

SELECT DISTINCT
sls_sales as old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
          THEN sls_quantity * ABS(sls_price)
     ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <= 0
          THEN sls_sales / NULLIF(sls_quantity, 0)
    ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <=0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

select * FROM silver.crm_sales_details

-- indentify out of range dates
SELECT DISTINCT
bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standardization & consistency 

 SELECT DISTINCT gen
 FROM silver.erp_cust_az12

 SELECT * FROM [silver].[crm_cust_info]

 SELECT * 
 FROM silver.erp_loc_a101

-- check for Nulls or Duplicates in primary key
-- Expectation: No Result

SELECT
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL

-- check for unwanted scpaes 
-- Expectation: No Result
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- data standardization and consistency 
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info
