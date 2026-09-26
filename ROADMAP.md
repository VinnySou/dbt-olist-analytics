# Roadmap

Lista de trabalho incremental do projeto. Cada dia (ou sessão de trabalho) marca
um item como feito e faz commit + push antes de sair. Não pule itens: a ordem
importa (marts dependem da staging, testes dependem dos marts existirem).

Antes de começar cada sessão: `git pull`, depois `DBT_PROFILES_DIR=. dbt build`
pra confirmar que o estado atual ainda passa, só então seguir pro próximo item.

- [x] Scaffold do projeto (dbt_project.yml, profiles.yml, requirements.txt)
- [x] Seeds sintéticos (scripts/generate_seed_data.py) + schema/tests da raw
- [x] Camada de staging completa (stg_olist__*, um por seed) + testes genéricos
- [x] `dim_customers`, `dim_sellers` (models/marts) — dimensões simples, direto da staging
- [x] `dim_products` — junta categoria já traduzida, adiciona `product_size_category` (pequeno/médio/grande por volume) como exemplo de lógica de negócio num mart
- [x] `dim_date` — calendário gerado com `dbt_utils.date_spine` (adicionar o pacote `dbt-labs/dbt_utils` em `packages.yml`)
- [x] `fct_order_items` (grão: item do pedido) — liga a `dim_products`/`dim_sellers`, preço e frete
- [x] `fct_orders` (grão: pedido) — agrega pagamento e nota, calcula tempo de entrega e atraso vs. estimativa
- [x] Testes de negócio (`tests/` singulares): nenhum valor de pedido negativo, nenhuma entrega com data anterior à compra, soma de `fct_order_items` por pedido bate com `fct_orders`
- [ ] `analyses/` com as perguntas de negócio (receita mensal, curva ABC de categoria, taxa de atraso por estado) — mesma ideia do `sql-server-vendas-analytics`, mas em dbt
- [ ] GitHub Actions: workflow rodando `dbt seed` + `dbt build` a cada push
- [ ] `dbt docs generate` + publicar os docs estáticos (GitHub Pages ou só documentar como gerar localmente)
- [ ] Exemplo de model incremental (`fct_order_items` como `materialized='incremental'`, com `is_incremental()`)
- [ ] Exemplo de snapshot (SCD tipo 2) — ex.: histórico de mudança de `order_status`
- [ ] README final: diagrama de lineage (dbt gera automaticamente), seção "por que dbt em vez de só SQL cru", comparação com o `olist-etl-powerbi` (mesma origem de dados, abordagem diferente: Python imperativo vs. SQL declarativo)
