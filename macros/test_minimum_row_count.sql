{% test minimum_row_count(model, min_rows) %}

-- Falha se a tabela tiver menos linhas que min_rows. Serve pra pegar
-- regressão de volume (ex.: scripts/generate_seed_data.py mudar e passar
-- a gerar poucas linhas, ou um seed ficar vazio por engano) sem exigir uma
-- contagem exata, que quebraria a cada ajuste legítimo do gerador.

with row_count as (

    select count(*) as n_rows
    from {{ model }}

)

select *
from row_count
where n_rows < {{ min_rows }}

{% endtest %}
