{% test minimum_row_count(model, min_rows) %}

-- Teste genérico de volume: falha se o model/seed tiver menos de `min_rows` linhas.
-- Usado nos seeds sintéticos pra pegar regressão caso scripts/generate_seed_data.py
-- mude e passe a gerar menos linhas do que o esperado.

with validation as (

    select count(*) as row_count
    from {{ model }}

)

select *
from validation
where row_count < {{ min_rows }}

{% endtest %}
