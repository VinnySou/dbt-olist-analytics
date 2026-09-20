# Olist Analytics — dbt

Transformação de dados em SQL declarativo com [dbt](https://www.getdbt.com/), sobre
o mesmo dataset (Olist, e-commerce brasileiro) do projeto
[`olist-etl-powerbi`](https://github.com/VinnySou/olist-etl-powerbi) — só que aqui a
abordagem é outra: em vez de um pipeline Python imperativo (extract/transform/load),
as transformações são modelos SQL versionados, testados e documentados pelo próprio
dbt.

**Este projeto está em construção incremental — ver [`ROADMAP.md`](ROADMAP.md)
para o que já foi feito e o que vem a seguir.**

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
models/marts/           dimensões e fatos prontos para consumo (em construção)
scripts/                gerador dos seeds sintéticos
tests/                   testes de negócio (singular tests)
analyses/                consultas de negócio versionadas (em construção)
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

## Stack

dbt-core · DuckDB · Python (geração dos seeds sintéticos)

---

## English

SQL-based transformation with dbt, over the same Olist e-commerce dataset used in
[`olist-etl-powerbi`](https://github.com/VinnySou/olist-etl-powerbi) — a deliberate
contrast: that project is an imperative Python ETL pipeline, this one is declarative
SQL models with dbt's built-in testing and documentation. Work in progress, see
[`ROADMAP.md`](ROADMAP.md) for current status.

```bash
pip install -r requirements.txt
python scripts/generate_seed_data.py
DBT_PROFILES_DIR=. dbt build
```

Runs entirely against a local DuckDB file, no cloud warehouse account needed to try it.
