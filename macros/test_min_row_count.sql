{% test min_row_count(model, min_rows) %}

-- Teste genérico: falha se o model/seed tiver menos de `min_rows` linhas.
-- Usado nos seeds pra pegar regressão caso scripts/generate_seed_data.py
-- passe a gerar um volume muito menor (ex.: silenciosamente gerar 0 linhas).

with row_count as (
    select count(*) as n_rows
    from {{ model }}
)

select *
from row_count
where n_rows < {{ min_rows }}

{% endtest %}
