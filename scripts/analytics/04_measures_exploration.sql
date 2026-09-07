/*
===============================================================================
Exploração das Medidas (Métricas-Chave) (PostgreSQL)
===============================================================================
Objetivo:
    - Calcular métricas agregadas (ex.: totais, médias) para insights rápidos.
    - Identificar tendências gerais ou detectar anomalias.

Funções SQL Utilizadas:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Encontra o total de vendas
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- Encontra quantos itens foram vendidos
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- Encontra o preço médio de venda
SELECT AVG(price) AS avg_price FROM gold.fact_sales;

-- Encontra o número total de pedidos
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- Encontra o número total de produtos
SELECT COUNT(product_name) AS total_products FROM gold.dim_product;

-- Encontra o número total de clientes
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customer;

-- Encontra o número total de clientes que já fizeram algum pedido
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Gera um relatório com todas as métricas-chave do negócio
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_product
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customer;
