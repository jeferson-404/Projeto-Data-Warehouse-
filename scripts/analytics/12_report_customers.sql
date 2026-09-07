/*
===============================================================================
Relatório de Clientes (PostgreSQL)
===============================================================================
Objetivo:
    - Este relatório consolida as principais métricas e comportamentos dos clientes.

Destaques:
    1. Reúne campos essenciais como nomes, idades e detalhes das transações.
    2. Segmenta os clientes em categorias (VIP, Regular, New) e faixas etárias.
    3. Agrega métricas em nível de cliente:
       - total de pedidos
       - total de vendas
       - quantidade total comprada
       - total de produtos
       - tempo de relacionamento (lifespan, em meses)
    4. Calcula KPIs importantes:
       - recência (meses desde o último pedido)
       - ticket médio (valor médio por pedido)
       - gasto médio mensal

Notas sobre a adaptação para PostgreSQL:
    - IF OBJECT_ID(...)/GO (T-SQL) foi substituído por DROP VIEW IF EXISTS
      (não é necessário usar GO).
    - DATEDIFF()/GETDATE() (T-SQL) foram substituídos por AGE()/EXTRACT()/CURRENT_DATE.
    - Nomes de tabela ajustados para o singular (dim_customer), para bater com
      as views deste projeto.
    - Corrigida uma vírgula faltante antes de "lifespan" na consulta final,
      que no script original transformava silenciosamente
      "total_products lifespan" em um alias implícito de coluna, em vez de
      duas colunas separadas.
===============================================================================
*/

-- =============================================================================
-- Criação do Relatório: gold.report_customers
-- =============================================================================
DROP VIEW IF EXISTS gold.report_customers;

CREATE VIEW gold.report_customers AS

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Consulta Base: Recupera as colunas principais das tabelas
---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.birthdate))::int AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customer c
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),

customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Agregação por Cliente: Resume as métricas-chave em nível de cliente
---------------------------------------------------------------------------*/
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        (EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12
            + EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))))::int AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

/*---------------------------------------------------------------------------
3) Consulta Final: Combina todos os resultados de clientes em uma única saída
---------------------------------------------------------------------------*/
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    last_order_date,
    (EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_order_date)) * 12
        + EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_order_date)))::int AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
    -- Calcula o Ticket Médio (Average Order Value - AOV)
    CASE WHEN total_orders = 0 THEN 0
         ELSE total_sales / total_orders
    END AS avg_order_value,
    -- Calcula o gasto médio mensal
    CASE WHEN lifespan = 0 THEN total_sales
         ELSE total_sales / lifespan
    END AS avg_monthly_spend
FROM customer_aggregation;
