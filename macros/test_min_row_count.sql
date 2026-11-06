{% test min_row_count(model, min_count) %}

-- Teste genérico de volume: falha se a relação tiver menos de `min_count`
-- linhas. Serve pra pegar regressão nos seeds sintéticos (ex.: alguém reduz
-- N_ORDERS em scripts/generate_seed_data.py e esquece de ajustar os models),
-- já que dbt não tem como validar "volume esperado" de um dado estático sem
-- essa checagem explícita.

with row_count as (
    select count(*) as n_rows
    from {{ model }}
)

select *
from row_count
where n_rows < {{ min_count }}

{% endtest %}
