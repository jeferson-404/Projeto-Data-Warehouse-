/*
===============================================================================
Análise de Mudança ao Longo do Tempo (PostgreSQL)
===============================================================================
Objetivo:
    - Acompanhar tendências, crescimento e mudanças nas métricas-chave ao longo do tempo.
    - Realizar análise de série temporal e identificar sazonalidade.
    - Medir crescimento ou queda em períodos específicos.

Funções SQL Utilizadas:
    - Funções de Data: EXTRACT(), DATE_TRUNC(), TO_CHAR()
    (as funções DATEPART()/DATETRUNC()/FORMAT() do T-SQL correspondem a
     EXTRACT()/DATE_TRUNC()/TO_CHAR() no PostgreSQL)
    - Funções de Agregação: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analisa a performance de vendas ao longo do tempo
-- Funções de data simples
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date);

-- DATE_TRUNC()
SELECT
    DATE_TRUNC('month', order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);

-- TO_CHAR()
-- Atenção: aqui o agrupamento/ordenação usa a data já formatada como texto
-- ("2023-Jan"), então a ordenação é alfabética, não cronológica
-- (ex.: "2023-Feb" aparece antes de "2023-Jan"). Se quiser ordem cronológica,
-- agrupe/ordene por DATE_TRUNC('month', order_date) e use TO_CHAR() só na exibição.
SELECT
    TO_CHAR(order_date, 'YYYY-Mon') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'YYYY-Mon')
ORDER BY TO_CHAR(order_date, 'YYYY-Mon');
