{% test minimum_row_count(model, min_rows) %}

{#
    Teste de volume: falha se a tabela/seed tiver menos de `min_rows` linhas.
    Serve pra pegar regressão caso o gerador sintético (scripts/generate_seed_data.py)
    mude e passe a gerar menos dados do que os models esperam.
#}

with row_count as (

    select count(*) as n_rows
    from {{ model }}

)

select *
from row_count
where n_rows < {{ min_rows }}

{% endtest %}
