{% test min_row_count(model, value) %}
-- Teste genérico: falha se o model/seed tiver menos de `value` linhas.
-- Serve de guarda de regressão para os seeds sintéticos (scripts/generate_seed_data.py):
-- se o gerador mudar e passar a emitir menos linhas que o esperado, o build quebra aqui
-- em vez de só aparecer como um número estranho mais na frente, na staging/marts.

with row_count as (
    select count(*) as n from {{ model }}
)

select n
from row_count
where n < {{ value }}

{% endtest %}
