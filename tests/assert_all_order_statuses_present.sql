-- Cada status esperado de pedido deve ter pelo menos uma linha em fct_orders.
-- accepted_values (ver _marts__models.yml) pega status inesperado; este teste pega o caso
-- complementar: o gerador sintético (scripts/generate_seed_data.py) para de sortear algum
-- dos status esperados, zerando a contagem sem violar accepted_values.
-- Retorna linhas (o teste falha) para cada status esperado com contagem zero.

with expected_statuses as (

    select unnest(['delivered', 'shipped', 'canceled']) as order_status

),

actual_counts as (

    select
        order_status,
        count(*) as n_orders
    from {{ ref('fct_orders') }}
    group by 1

)

select
    expected_statuses.order_status,
    coalesce(actual_counts.n_orders, 0) as n_orders
from expected_statuses
left join actual_counts
    on expected_statuses.order_status = actual_counts.order_status
where coalesce(actual_counts.n_orders, 0) = 0
