{% test at_least_one_row_per_value(model, column_name, values) %}

{#
    Complementa o accepted_values: aquele só garante que a coluna não tem valor fora
    da lista, mas passa mesmo se algum valor esperado tiver zero linhas. Esse aqui
    falha quando isso acontece, pra pegar regressão no mix de valores gerado pelo
    seed sintético (ex.: scripts/generate_seed_data.py parar de gerar um status).
#}

with expected_values as (

    {% for value in values %}
    select '{{ value }}' as expected_value
    {% if not loop.last %}union all{% endif %}
    {% endfor %}

),

actual_counts as (

    select
        {{ column_name }} as actual_value,
        count(*) as n_rows
    from {{ model }}
    group by 1

)

select
    expected_values.expected_value,
    coalesce(actual_counts.n_rows, 0) as n_rows
from expected_values
left join actual_counts
    on expected_values.expected_value = actual_counts.actual_value
where coalesce(actual_counts.n_rows, 0) = 0

{% endtest %}
