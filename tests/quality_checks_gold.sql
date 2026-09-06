/*
===============================================================================
Quality Checks - Gold Layer
===============================================================================
Script Purpose 
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables/views.
    - Referential integrity between fact and dimension tables/views.
    - Validation of relationships in the data model for analytical purposes.

Proposito do Script 
    Este script realiza verificacoes de qualidade para validar a integridade,
    consistencia e precisao da camada Gold. Estas checagens garantem:
    - Unicidade das chaves substitutas (surrogate keys) nas dimensoes.
    - Integridade referencial entre a tabela fato e as dimensoes.
    - Validacao dos relacionamentos no modelo de dados para fins analiticos.

Usage Notes / Notas de Uso:
    - Investigate and resolve any discrepancies found during the checks.
      Investigue e resolva qualquer discrepancia encontrada.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customer'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customer
-- Verifica a unicidade da customer_key em gold.dim_customer
-- Expectation / Esperado: No results / Nenhum resultado
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_product'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_product
-- Verifica a unicidade da product_key em gold.dim_product
-- Expectation / Esperado: No results / Nenhum resultado
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_product
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
-- Verifica a conectividade do modelo de dados entre fato e dimensoes
-- Expectation / Esperado: No results / Nenhum resultado
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_product p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
