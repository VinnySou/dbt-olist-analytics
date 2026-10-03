# Olist Analytics — dbt

[![dbt-build](https://github.com/VinnySou/dbt-olist-analytics/actions/workflows/dbt-build.yml/badge.svg)](https://github.com/VinnySou/dbt-olist-analytics/actions/workflows/dbt-build.yml)
📖 [Documentação e lineage gerados pelo dbt](https://vinnysou.github.io/dbt-olist-analytics/)

Transformação de dados em SQL declarativo com [dbt](https://www.getdbt.com/), sobre
o mesmo dataset (Olist, e-commerce brasileiro) do projeto
[`olist-etl-powerbi`](https://github.com/VinnySou/olist-etl-powerbi) — só que aqui a
abordagem é outra: em vez de um pipeline Python imperativo (extract/transform/load),
as transformações são modelos SQL versionados, testados e documentados pelo próprio
dbt.

**Este projeto está em construção incremental — ver [`ROADMAP.md`](ROADMAP.md)
para o que já foi feito e o que vem a seguir.**

### O que este projeto demonstra

- **Modelagem dimensional**: camada de staging (7 views, uma por fonte) →
  marts em esquema estrela (`dim_customers`, `dim_sellers`, `dim_products`,
  `dim_date`, `fct_order_items`, `fct_orders`), com lógica de negócio
  documentada em cada model (ex.: classificação de porte de produto, cálculo
  de atraso de entrega vs. estimativa).
- **Qualidade de dados como código**: 70 testes automatizados (genéricos —
  `not_null`, `unique`, `relationships` — e de negócio, como "nenhum pedido
  com valor negativo" ou "soma dos itens bate com o pagamento"), rodando a
  cada push.
- **Histórico de mudanças (SCD tipo 2)**: snapshot (`snap_orders_status`)
  rastreia mudanças de `order_status` ao longo do tempo via estratégia
  `check` do dbt.
- **CI/CD**: GitHub Actions builda o projeto inteiro (`seed` + `run` + `test`)
  a cada push/PR e publica a documentação técnica automaticamente.
- **Dados sintéticos reprodutíveis**: gerador Python que recria o schema real
  da Olist sem depender de um dump de dados de produção.
- **Análises de negócio versionadas**: receita mensal, curva ABC de
  categoria e taxa de atraso por estado, como consultas SQL auditáveis em
  `analyses/`.

## Por que dbt (e quando não usar)

dbt brilha quando a transformação é toda dentro de um banco/warehouse (SQL puro,
com `ref()` resolvendo a ordem de execução, testes declarativos e documentação
gerada automaticamente a partir do próprio código). Não é a ferramenta certa
quando a transformação depende de lógica que SQL não expressa bem (chamadas de
API, modelos de ML, arquivos binários) — aí um pipeline Python como o
`olist-etl-powerbi` continua fazendo mais sentido. Os dois projetos juntos mostram
os dois lados dessa decisão.

## Estrutura

```
seeds/                dados sintéticos (schema do dataset real da Olist)
models/staging/        um model por seed: renomeia colunas, tipa, limpa
models/marts/           dimensões e fatos prontos para consumo (esquema estrela)
snapshots/               histórico de mudanças (SCD tipo 2) de order_status
scripts/                gerador dos seeds sintéticos
tests/                   testes de negócio (singular tests)
analyses/                consultas de negócio versionadas (receita mensal, curva ABC, atraso por estado)
```

## Como executar

```bash
git clone https://github.com/VinnySou/dbt-olist-analytics.git
cd dbt-olist-analytics
python -m venv .venv && source .venv/Scripts/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt

python scripts/generate_seed_data.py
DBT_PROFILES_DIR=. dbt build
```

Roda tudo (`seed` + `run` + `test`) sobre um DuckDB local (`dev.duckdb`, ignorado
pelo git) — não precisa de nenhuma conta de warehouse na nuvem pra testar.

Para ver o grafo de dependências e a documentação gerada:

```bash
DBT_PROFILES_DIR=. dbt docs generate
DBT_PROFILES_DIR=. dbt docs serve
```

Os docs também são publicados automaticamente a cada push em `main` (workflow
`dbt-build`, job `publish-docs`), em:
**https://vinnysou.github.io/dbt-olist-analytics/**

## Stack

dbt-core · DuckDB · Python (geração dos seeds sintéticos)

---

## English

📖 [Generated docs and lineage graph](https://vinnysou.github.io/dbt-olist-analytics/)

SQL-based transformation with dbt, over the same Olist e-commerce dataset used in
[`olist-etl-powerbi`](https://github.com/VinnySou/olist-etl-powerbi) — a deliberate
contrast: that project is an imperative Python ETL pipeline, this one is declarative
SQL models with dbt's built-in testing and documentation. Work in progress, see
[`ROADMAP.md`](ROADMAP.md) for current status.

**What this demonstrates:** dimensional modeling (staging views → star-schema
marts), 70 automated data-quality tests (generic + business rules), a type-2
slowly-changing-dimension snapshot tracking `order_status` history, CI/CD via
GitHub Actions (build + docs publishing on every push), reproducible synthetic
data generation, and versioned business analyses (SQL) alongside the models.

```bash
pip install -r requirements.txt
python scripts/generate_seed_data.py
DBT_PROFILES_DIR=. dbt build
```

Runs entirely against a local DuckDB file, no cloud warehouse account needed to try it.
