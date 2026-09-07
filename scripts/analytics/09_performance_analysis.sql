/*
===============================================================================
Análise de Performance (Ano a Ano, Mês a Mês) (PostgreSQL)
===============================================================================
Objetivo:
    - Medir a performance de produtos, clientes ou regiões ao longo do tempo.
    - Realizar benchmarking e identificar entidades de alto desempenho.
    - Acompanhar tendências e crescimento anuais.

Funções SQL Utilizadas:
    - LAG(): Acessa dados de linhas anteriores.
    - AVG() OVER(): Calcula médias dentro de partições.
    - CASE: Define lógica condicional para análise de tendência.
    - EXTRACT() (equivalente no PostgreSQL ao YEAR() do T-SQL)
===============================================================================
*/

/* Analisa a performance anual dos produtos, comparando suas vendas
tanto com a média histórica de vendas do produto quanto com o ano anterior */
WITH yearly_product_sales AS (
    SELECT
        EXTRACT(YEAR FROM f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_product p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        EXTRACT(YEAR FROM f.order_date),
        p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    -- Análise Ano a Ano (Year-over-Year)
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
