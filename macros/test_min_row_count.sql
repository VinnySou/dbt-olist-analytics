{% test min_row_count(model, min_rows) %}
-- Teste genérico de volume: falha se a tabela/seed tiver menos de `min_rows`
-- linhas. Serve pra pegar regressão caso o gerador sintético (ou uma fonte
-- real, no futuro) passe a produzir uma amostra vazia ou muito menor do
-- que o esperado.

select count(*) as row_count
from {{ model }}
having count(*) < {{ min_rows }}

{% endtest %}
