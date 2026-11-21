{% test min_row_count(model, min_count) %}

{#
    Falha se o model/seed tiver menos de `min_count` linhas.
    Serve como teste de volume: pega regressão caso o gerador sintético
    (scripts/generate_seed_data.py) passe a gerar menos linhas do que o
    esperado, já que os seeds não têm coluna de data pra um teste de
    freshness (dbt_utils.recency) fazer sentido.
#}

with row_count as (

    select count(*) as n_rows
    from {{ model }}

)

select *
from row_count
where n_rows < {{ min_count }}

{% endtest %}
