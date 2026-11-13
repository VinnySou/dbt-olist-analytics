{% test minimum_row_count(model, min_rows) %}

{#
    Teste de volume: falha se o seed/model tiver menos de `min_rows` linhas.
    Pensado para pegar regressão no scripts/generate_seed_data.py (ex.: alguém
    reduz N_* por engano e o seed passa a sair quase vazio sem que nenhum
    teste de coluna perceba).
#}

with validation as (

    select count(*) as row_count
    from {{ model }}

)

select *
from validation
where row_count < {{ min_rows }}

{% endtest %}
