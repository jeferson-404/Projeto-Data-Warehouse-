/*
===============================================================================
Relatório de Produtos (PostgreSQL)
===============================================================================
Objetivo:
    - Este relatório consolida as principais métricas e comportamentos dos produtos.

Destaques:
    1. Reúne campos essenciais como nome do produto, categoria, subcategoria e custo.
    2. Segmenta os produtos por receita para identificar High-Performers,
       Mid-Range ou Low-Performers.
    3. Agrega métricas em nível de produto:
       - total de pedidos
       - total de vendas
       - quantidade total vendida
       - total de clientes (únicos)
       - tempo de relacionamento (lifespan, em meses)
    4. Calcula KPIs importantes:
       - recência (meses desde a última venda)
       - receita média por pedido (AOR)
       - receita média mensal

Notas sobre a adaptação para PostgreSQL:
    - IF OBJECT_ID(...)/GO (T-SQL) foi substituído por DROP VIEW IF EXISTS
      (não é necessário usar GO).
    - DATEDIFF()/GETDATE() (T-SQL) foram substituídos por AGE()/EXTRACT()/CURRENT_DATE.
    - Nomes de tabela ajustados para o singular (dim_product), para bater com
      as views deste projeto.
===============================================================================
*/
-- =============================================================================
-- Criação do Relatório: gold.report_products
-- =============================================================================
DROP VIEW IF EXISTS gold.report_products;

CREATE VIEW gold.report_products AS

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Consulta Base: Recupera as colunas principais de fact_sales e dim_product
---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_product p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL  -- considera apenas vendas com data válida
),

product_aggregations AS (
/*---------------------------------------------------------------------------
2) Agregação por Produto: Resume as métricas-chave em nível de produto
---------------------------------------------------------------------------*/
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        (EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12
            + EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))))::int AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(sales_amount::numeric / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

/*---------------------------------------------------------------------------
  3) Consulta Final: Combina todos os resultados de produtos em uma única saída
---------------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    (EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_sale_date)) * 12
        + EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_sale_date)))::int AS recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    -- Receita Média por Pedido (Average Order Revenue - AOR)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,
    -- Receita Média Mensal
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue
FROM product_aggregations;
