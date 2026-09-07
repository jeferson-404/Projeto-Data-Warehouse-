/*
===============================================================================
Exploração do Intervalo de Datas (PostgreSQL)
===============================================================================
Objetivo:
    - Determinar os limites temporais dos principais dados.
    - Entender o intervalo dos dados históricos.

Funções SQL Utilizadas:
    - MIN(), MAX(), AGE(), EXTRACT()
    (as funções DATEDIFF()/GETDATE() do T-SQL não têm equivalente direto no
     PostgreSQL; por isso usamos AGE() + EXTRACT())
===============================================================================
*/

-- Determina a primeira e a última data de pedido e a duração total em meses
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    (EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12
        + EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))))::int AS order_range_months
FROM gold.fact_sales;

-- Encontra o cliente mais novo e o mais velho com base na data de nascimento
SELECT
    MIN(birthdate) AS oldest_birthdate,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(birthdate)))::int AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, MAX(birthdate)))::int AS youngest_age
FROM gold.dim_customer;
