# Catálogo de Dados da Camada Gold

## Visão Geral
A camada Gold é a representação dos dados em nível de negócio, estruturada para dar suporte a casos de uso analíticos e de relatórios. Ela é composta por **tabelas de dimensão** e **tabelas de fato** para métricas específicas do negócio.

---

### 1. **gold.dim_customer**
- **Propósito:** Armazena os detalhes dos clientes, enriquecidos com dados demográficos e geográficos.
- **Colunas:**

| Nome da Coluna    | Tipo de Dado  | Descrição                                                                                     |
|-------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key      | INT           | Chave substituta (surrogate key) que identifica de forma única cada registro de cliente na tabela de dimensão. |
| customer_id       | INT           | Identificador numérico único atribuído a cada cliente.                                        |
| customer_number   | VARCHAR(50)   | Identificador alfanumérico que representa o cliente, usado para rastreamento e referência.     |
| first_name        | VARCHAR(50)   | Primeiro nome do cliente, conforme registrado no sistema.                                      |
| last_name         | VARCHAR(50)   | Sobrenome do cliente.                                                                           |
| country           | VARCHAR(50)   | País de residência do cliente (ex.: 'Australia').                                              |
| marital_status    | VARCHAR(50)   | Estado civil do cliente (ex.: 'Married', 'Single').                                            |
| gender            | VARCHAR(50)   | Gênero do cliente (ex.: 'Male', 'Female', 'n/a').                                              |
| birthdate         | DATE          | Data de nascimento do cliente, no formato AAAA-MM-DD (ex.: 1971-10-06).                        |
| create_date       | DATE          | Data em que o registro do cliente foi criado no sistema.                                       |

---

### 2. **gold.dim_product**
- **Propósito:** Fornece informações sobre os produtos e seus atributos.
- **Colunas:**

| Nome da Coluna    | Tipo de Dado  | Descrição                                                                                     |
|-------------------|---------------|------------------------------------------------------------------------------------------------|
| product_key       | INT           | Chave substituta (surrogate key) que identifica de forma única cada registro de produto na dimensão. |
| product_id        | INT           | Identificador único atribuído ao produto para rastreamento interno.                            |
| product_number    | VARCHAR(50)   | Código alfanumérico estruturado que representa o produto, geralmente usado para categorização ou controle de estoque. |
| product_name      | VARCHAR(50)   | Nome descritivo do produto, incluindo detalhes como tipo, cor e tamanho.                        |
| category_id       | VARCHAR(50)   | Identificador único da categoria do produto, ligando-o à sua classificação de alto nível.       |
| category          | VARCHAR(50)   | Classificação ampla do produto (ex.: Bikes, Components), usada para agrupar itens relacionados. |
| subcategory       | VARCHAR(50)   | Classificação mais detalhada do produto dentro da categoria, como o tipo do produto.            |
| maintenance       | VARCHAR(50)   | Indica se o produto requer manutenção (ex.: 'Yes', 'No').                                       |
| cost              | INT           | Custo ou preço base do produto, em unidades monetárias.                                        |
| product_line      | VARCHAR(50)   | Linha ou série específica do produto (ex.: Road, Mountain).                                    |
| start_date        | DATE          | Data em que o produto ficou disponível para venda ou uso.                                      |

---

### 3. **gold.fact_sales**
- **Propósito:** Armazena os dados transacionais de vendas para fins analíticos.
- **Colunas:**

| Nome da Coluna   | Tipo de Dado  | Descrição                                                                                     |
|------------------|---------------|------------------------------------------------------------------------------------------------|
| order_number     | VARCHAR(50)   | Identificador alfanumérico único de cada pedido de venda (ex.: 'SO54496').                     |
| product_key      | INT           | Chave substituta que liga o pedido à tabela de dimensão de produto.                            |
| customer_key     | INT           | Chave substituta que liga o pedido à tabela de dimensão de cliente.                             |
| order_date       | DATE          | Data em que o pedido foi realizado.                                                             |
| shipping_date    | DATE          | Data em que o pedido foi enviado ao cliente.                                                    |
| due_date         | DATE          | Data de vencimento do pagamento do pedido.                                                      |
| sales_amount     | INT           | Valor monetário total da venda para o item, em unidades inteiras de moeda (ex.: 25).           |
| quantity         | INT           | Quantidade de unidades do produto pedidas para o item (ex.: 1).                                 |
| price            | INT           | Preço unitário do produto para o item, em unidades inteiras de moeda (ex.: 25).                 |
