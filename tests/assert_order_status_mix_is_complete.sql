-- accepted_values em fct_orders.order_status garante que não aparece status fora de
-- var('expected_order_statuses'); este teste cobre o caso oposto, que accepted_values não
-- pega: algum status esperado sumir do mix (ficar com 0 linhas) por uma regressão no gerador
-- sintético (scripts/generate_seed_data.py), e não um bug nos models.
-- Retorna linhas (teste falha) para cada status esperado sem nenhum pedido.

with expected_status as (
    select unnest({{ var('expected_order_statuses') }}) as order_status
),

actual_status_counts as (
    select order_status, count(*) as n_orders
    from {{ ref('fct_orders') }}
    group by 1
)

select
    expected_status.order_status,
    coalesce(actual_status_counts.n_orders, 0) as n_orders
from expected_status
left join actual_status_counts on expected_status.order_status = actual_status_counts.order_status
where coalesce(actual_status_counts.n_orders, 0) = 0
