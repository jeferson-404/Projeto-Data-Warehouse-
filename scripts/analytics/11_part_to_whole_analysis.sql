/*
===============================================================================
Análise Parte-Todo (PostgreSQL)
===============================================================================
Objetivo:
    - Comparar performance ou métricas entre dimensões ou períodos de tempo.
    - Avaliar diferenças entre categorias.
    - Útil para testes A/B ou comparações regionais.

Funções SQL Utilizadas:
    - SUM(), AVG(): Agregam valores para comparação.
    - Window Functions: SUM() OVER() para cálculo de totais gerais.
===============================================================================
*/
-- Quais categorias mais contribuem para o total de vendas?
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_product p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND((total_sales::numeric / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
