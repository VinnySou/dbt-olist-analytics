-- Cada status esperado de order_status deve ter pelo menos 1 pedido em fct_orders.
-- accepted_values (schema.yml) já pega valor fora da lista; este teste pega o caso
-- contrário: o gerador sintético (scripts/generate_seed_data.py) para de produzir
-- algum dos status esperados (ex.: ORDER_STATUSES vira só delivered/shipped).
-- Retorna linhas quando esse invariante é violado (teste falha se houver alguma linha).

with expected_statuses as (
    select *
    from (values ('delivered'), ('shipped'), ('canceled')) as t(order_status)
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
left join actual_counts on expected_statuses.order_status = actual_counts.order_status
where coalesce(actual_counts.n_orders, 0) = 0
