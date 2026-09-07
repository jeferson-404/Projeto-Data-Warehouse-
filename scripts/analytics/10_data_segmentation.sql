/*
===============================================================================
Análise de Segmentação de Dados (PostgreSQL)
===============================================================================
Objetivo:
    - Agrupar os dados em categorias significativas para insights direcionados.
    - Útil para segmentação de clientes, categorização de produtos ou análise regional.

Funções SQL Utilizadas:
    - CASE: Define a lógica de segmentação personalizada.
    - GROUP BY: Agrupa os dados em segmentos.
    - AGE()/EXTRACT() (equivalente no PostgreSQL ao DATEDIFF() do T-SQL)
===============================================================================
*/

/* Segmenta os produtos em faixas de custo e
conta quantos produtos caem em cada segmento */
WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_product
)
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/* Agrupa os clientes em três segmentos com base no comportamento de gasto:
	- VIP: clientes com pelo menos 12 meses de histórico e gasto acima de €5.000.
	- Regular: clientes com pelo menos 12 meses de histórico, mas gasto de até €5.000.
	- New: clientes com menos de 12 meses de histórico.
E encontra o número total de clientes em cada grupo
*/
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(f.order_date) AS first_order,
        MAX(f.order_date) AS last_order,
        (EXTRACT(YEAR FROM AGE(MAX(f.order_date), MIN(f.order_date))) * 12
            + EXTRACT(MONTH FROM AGE(MAX(f.order_date), MIN(f.order_date))))::int AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customer c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;
