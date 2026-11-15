{% test minimum_row_count(model, min_rows) %}

{#
    Teste genérico de volume: falha se a tabela/seed tiver menos de `min_rows`
    linhas. Serve pra pegar regressão caso o gerador sintético (ou uma fonte
    real, no futuro) passe a produzir menos dados do que o esperado, mesmo
    que todos os outros testes (not_null, unique, etc.) continuem passando.
#}

with row_count as (

    select count(*) as n_rows
    from {{ model }}

)

select *
from row_count
where n_rows < {{ min_rows }}

{% endtest %}
