/*
===============================================================================
Quality Checks - Silver Layer
===============================================================================
Script Purpose
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Proposito do Script
    Este script realiza diversas verificacoes de qualidade para consistencia,
    precisao e padronizacao dos dados na camada 'silver'. Inclui checagens de:
    - Chaves primarias nulas ou duplicadas.
    - Espacos indesejados em campos de texto.
    - Padronizacao e consistencia dos dados.
    - Intervalos e ordens de datas invalidas.
    - Consistencia entre campos relacionados.

Usage Notes / Notas de Uso:
    - Run these checks after loading the Silver Layer.
      Rode estas verificacoes depois de carregar a camada Silver.
    - Investigate and resolve any discrepancies found.
      Investigue e resolva qualquer discrepancia encontrada.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Verifica NULLs ou duplicidade na chave primaria
-- Expectation / Esperado: No Results / Nenhum resultado
SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces
-- Verifica espacos indesejados
-- Expectation / Esperado: No Results / Nenhum resultado
SELECT
    cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
-- Padronizacao e consistencia dos dados
SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;

-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Verifica NULLs ou duplicidade na chave primaria
-- Expectation / Esperado: No Results / Nenhum resultado
SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
-- Verifica espacos indesejados
-- Expectation / Esperado: No Results / Nenhum resultado
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Values in Cost
-- Verifica NULLs ou valores negativos no custo
-- Expectation / Esperado: No Results / Nenhum resultado
SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
-- Padronizacao e consistencia dos dados
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders (Start Date > End Date)
-- Verifica ordem invalida de datas (Data Inicio > Data Fim)
-- Expectation / Esperado: No Results / Nenhum resultado
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================
-- Check for Invalid Dates (raw values, checked on Bronze before conversion)
-- Verifica datas invalidas (valores brutos, checados na Bronze antes da conversao)
-- Expectation / Esperado: No Invalid Dates / Nenhuma data invalida
SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR LENGTH(sls_due_dt::text) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Verifica ordem invalida de datas (Data Pedido > Data Envio/Vencimento)
-- Expectation / Esperado: No Results / Nenhum resultado
SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales = Quantity * Price
-- Verifica consistencia: Venda = Quantidade * Preco
-- Expectation / Esperado: No Results / Nenhum resultado
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================
-- Identify Out-of-Range Dates
-- Identifica datas fora do intervalo esperado
-- Expectation / Esperado: Birthdates between 1924-01-01 and Today
--                         Datas de nascimento entre 1924-01-01 e hoje
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > CURRENT_DATE;

-- Data Standardization & Consistency
-- Padronizacao e consistencia dos dados
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;

-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================
-- Data Standardization & Consistency
-- Padronizacao e consistencia dos dados
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================
-- Check for Unwanted Spaces
-- Verifica espacos indesejados
-- Expectation / Esperado: No Results / Nenhum resultado
SELECT
    *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
-- Padronizacao e consistencia dos dados
SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;
