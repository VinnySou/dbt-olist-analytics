{% test min_row_count(model, min_rows) %}

{#
    Teste de volume: falha se o model/seed tiver menos de `min_rows` linhas.
    Serve para pegar regressão caso o gerador sintético (scripts/generate_seed_data.py)
    passe a gerar menos dados do que o esperado, já que não há uma fonte real
    de freshness (os seeds não têm timestamp de carga) para usar dbt_utils.recency.
#}

select count(*) as row_count
from {{ model }}
having count(*) < {{ min_rows }}

{% endtest %}
