/*
===============================================================================
Análise Cumulativa (PostgreSQL)
===============================================================================
Objetivo:
    - Calcular totais acumulados (running totals) ou médias móveis para métricas-chave.
    - Acompanhar a performance ao longo do tempo de forma cumulativa.
    - Útil para análise de crescimento ou identificação de tendências de longo prazo.

Funções SQL Utilizadas:
    - Window Functions: SUM() OVER(), AVG() OVER()
    - DATE_TRUNC() (equivalente no PostgreSQL ao DATETRUNC() do T-SQL)
===============================================================================
*/

-- Calcula o total de vendas por ano
-- e o total acumulado (running total) de vendas ao longo do tempo
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
    AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT
        DATE_TRUNC('year', order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_TRUNC('year', order_date)
) t;
