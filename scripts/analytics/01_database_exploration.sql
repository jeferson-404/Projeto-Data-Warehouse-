/*
===============================================================================
Exploração do Banco de Dados (PostgreSQL)
===============================================================================
Objetivo:
    - Explorar a estrutura do banco de dados, incluindo a lista de tabelas e seus schemas.
    - Inspecionar as colunas e metadados de tabelas específicas.

Tabelas Utilizadas:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Recupera a lista de todas as tabelas do banco de dados
SELECT
    table_catalog,
    table_schema,
    table_name,
    table_type
FROM information_schema.tables;

-- Recupera todas as colunas de uma tabela específica (dim_customer)
SELECT
    column_name,
    data_type,
    is_nullable,
    character_maximum_length
FROM information_schema.columns
WHERE table_name = 'dim_customer';
