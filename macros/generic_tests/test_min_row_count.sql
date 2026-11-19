{% test min_row_count(model, value) %}

{#
    Falha se o model/seed tiver menos de `value` linhas.
    Serve de teste de volume para os seeds sintéticos: se o gerador
    (scripts/generate_seed_data.py) for alterado e passar a gerar menos
    linhas do que o esperado, o build quebra em vez de passar silenciosamente.
#}

with row_count as (

    select count(*) as n_rows
    from {{ model }}

)

select *
from row_count
where n_rows < {{ value }}

{% endtest %}
