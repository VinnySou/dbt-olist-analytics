{% test minimum_row_count(model, min_row_count) %}
-- falha se o seed tiver menos linhas que o esperado (regressão no gerador sintético)

select row_count
from (
    select count(*) as row_count
    from {{ model }}
) counted
where row_count < {{ min_row_count }}

{% endtest %}
