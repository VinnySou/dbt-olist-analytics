{% test min_row_count(model, min_rows) %}

{#
    Falha se o seed/model tiver menos linhas que `min_rows`. Pensado pros seeds
    sintéticos: pega regressão caso scripts/generate_seed_data.py mude e passe a
    gerar uma amostra vazia ou muito menor do que o esperado.
#}

with validation as (

    select count(*) as row_count
    from {{ model }}

)

select *
from validation
where row_count < {{ min_rows }}

{% endtest %}
