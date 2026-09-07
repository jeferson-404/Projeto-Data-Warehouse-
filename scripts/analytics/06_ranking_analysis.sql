/*
===============================================================================
Análise de Ranking (PostgreSQL)
===============================================================================
Objetivo:
    - Ranquear itens (ex.: produtos, clientes) com base em desempenho ou outras métricas.
    - Identificar os melhores e os piores desempenhos.

Funções SQL Utilizadas:
    - Funções de Ranking (Window Functions): RANK(), DENSE_RANK(), ROW_NUMBER()
    - Cláusulas: GROUP BY, ORDER BY, LIMIT
    (o T-SQL usa TOP N, que não existe como palavra-chave no PostgreSQL;
     usamos LIMIT N, que fica no FINAL da consulta, depois do ORDER BY)
===============================================================================
*/

-- Quais são os 5 produtos que geram a maior receita?
-- Ranking simples
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Ranking mais complexo e flexível usando Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_product p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- Quais são os 5 produtos com pior desempenho em vendas?
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue
LIMIT 5;

-- Encontra os 10 clientes que geraram a maior receita
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Os 3 clientes com o menor número de pedidos realizados
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders
LIMIT 3;
