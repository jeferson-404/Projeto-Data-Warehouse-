/*
===============================================================================
Análise de Magnitude (PostgreSQL)
===============================================================================
Objetivo:
    - Quantificar os dados e agrupar os resultados por dimensões específicas.
    - Entender a distribuição dos dados entre categorias.

Funções SQL Utilizadas:
    - Funções de Agregação: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Encontra o total de clientes por país
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customer
GROUP BY country
ORDER BY total_customers DESC;

-- Encontra o total de clientes por gênero
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customer
GROUP BY gender
ORDER BY total_customers DESC;

-- Encontra o total de produtos por categoria
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_product
GROUP BY category
ORDER BY total_products DESC;

-- Qual é o custo médio em cada categoria?
SELECT
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_product
GROUP BY category
ORDER BY avg_cost DESC;

-- Qual é a receita total gerada por cada categoria?
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Qual é a receita total gerada por cada cliente?
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
ORDER BY total_revenue DESC;

-- Qual é a distribuição de itens vendidos entre os países?
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
