/*
===============================================================================
Exploração das Dimensões (PostgreSQL)
===============================================================================
Objetivo:
    - Explorar a estrutura das tabelas de dimensão.

Funções SQL Utilizadas:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Recupera a lista de países de origem dos clientes
SELECT DISTINCT
    country
FROM gold.dim_customer
ORDER BY country;

-- Recupera a lista de categorias, subcategorias e produtos
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_product
ORDER BY category, subcategory, product_name;
