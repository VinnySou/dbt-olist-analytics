{% test min_row_count(model, min_count) %}

-- Teste de volume: falha se a tabela tiver menos linhas que min_count.
-- Usado nos seeds pra pegar regressão caso scripts/generate_seed_data.py
-- mude e passe a gerar poucas (ou nenhuma) linha sem ninguém notar.

with row_count as (
    select count(*) as n from {{ model }}
)

select *
from row_count
where n < {{ min_count }}

{% endtest %}
