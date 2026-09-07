# Projeto de Data Warehouse e Analytics

Bem-vindo(a) ao repositório do **Projeto de Data Warehouse e Analytics**! 🚀
Este projeto demonstra uma solução completa de data warehousing e analytics, desde a construção de um data warehouse até a geração de insights.

---
## 🏗️ Arquitetura de Dados

A arquitetura de dados deste projeto segue a Arquitetura Medalhão, com as camadas **Bronze**, **Silver** e **Gold**:
![Arquitetura de Dados](docs/data_architecture.png)

1. **Camada Bronze**: Armazena os dados brutos exatamente como vêm dos sistemas de origem. Os dados são carregados a partir de arquivos CSV para um banco de dados **PostgreSQL**.
2. **Camada Silver**: Esta camada inclui processos de limpeza, padronização e normalização dos dados para prepará-los para análise.
3. **Camada Gold**: Contém os dados prontos para o negócio, modelados em esquema estrela (`gold.dim_customer`, `gold.dim_product`, `gold.fact_sales`) necessários para relatórios e análises.

---
## 📖 Visão Geral do Projeto

Este projeto envolve:

1. **Arquitetura de Dados**: Desenho de um data warehouse moderno usando a Arquitetura Medalhão com as camadas **Bronze**, **Silver** e **Gold**.
2. **Pipelines de ETL**: Extração, transformação e carga de dados dos sistemas de origem para o data warehouse, usando stored procedures em PostgreSQL (`plpgsql`).
3. **Modelagem de Dados**: Desenvolvimento de views de fato e dimensão otimizadas para consultas analíticas.
4. **Analytics e Relatórios**: Criação de relatórios e dashboards baseados em SQL para gerar insights acionáveis.


---


## 🚀 Requisitos do Projeto

### Construção do Data Warehouse

#### Objetivo
Desenvolver um data warehouse moderno usando PostgreSQL para consolidar os dados de vendas, possibilitando relatórios analíticos e tomada de decisão informada.

#### Especificações
- **Fontes de Dados**: Importar dados de dois sistemas de origem (ERP e CRM), fornecidos como arquivos CSV.
- **Qualidade de Dados**: Limpar e resolver problemas de qualidade de dados antes da análise.
- **Integração**: Combinar as duas fontes em um único modelo de dados amigável, projetado para consultas analíticas.
- **Escopo**: Focar apenas no conjunto de dados mais recente; não é necessário historizar os dados.
- **Documentação**: Fornecer documentação clara do modelo de dados para dar suporte tanto às áreas de negócio quanto às equipes de analytics.

---

### BI: Analytics e Relatórios (Análise de Dados)

#### Objetivo
Desenvolver análises baseadas em SQL para entregar insights detalhados sobre:
- **Comportamento do Cliente**
- **Performance de Produtos**
- **Tendências de Vendas**

Esses insights capacitam as áreas de negócio com métricas-chave, permitindo decisões estratégicas.

## 📂 Estrutura do Repositório
``
data-warehouse-project/
│
├── datasets/                           # Datasets brutos usados no projeto (dados de ERP e CRM)
│   ├── source_crm/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   └── source_erp/
│       ├── cust_az12.csv
│       ├── loc_a101.csv
│       └── px_cat_g1v2.csv
│
├── docs/                               # Documentação do projeto e detalhes da arquitetura
│   ├── data_architecture.png           # Arquivo mostrando a arquitetura do projeto
│   ├── data_catalog.md                 # Catálogo dos datasets, com descrição dos campos e metadados
│   ├── data_flow.png                   # Diagrama de fluxo de dados
│   └── naming-conventions.md           # Diretrizes de nomenclatura para tabelas, colunas e arquivos
│
├── scripts/                            # Scripts SQL (PostgreSQL / plpgsql) para ETL e transformações
│   ├── bronze/
│   │   ├── ddl_bronze.sql              # Criação das tabelas Bronze
│   │   └── load_bronze.sql             # Stored Procedure para carga dos dados
│   ├── silver/
│   │   ├── ddl_silver.sql              # Criação das tabelas Silver
│   │   └── load_silver.sql             # Stored Procedure para transformação e limpeza
│   ├── gold/
│   │   └── fact_sales.sql              # Criação das views analíticas (Star Schema)
│   └── analytics/                      # Scripts de análise (01 a 13)
│       ├── 01_database_exploration.sql
│       ├── 02_dimensions_exploration.sql
│       ├── ...
│       ├── 12_report_customers.sql
│       └── 13_report_products.sql
│
├── tests/                              # Scripts de verificação de qualidade dos dados
│   ├── quality_checks_silver.sql
│   └── quality_checks_gold.sql
│
├── README.md                           # Visão geral do projeto e instruções
├── LICENSE                             # Informações de licença do repositório
└── .gitignore                          # Arquivos e pastas ignorados pelo Git
```
