-- accepted_values valida que order_status não tem valores fora da lista, mas
-- passaria mesmo se um dos status sumisse por completo da amostra (ex.: o
-- gerador sintético zerar o peso de 'canceled' em ORDER_STATUSES). Este teste
-- cobre esse caso: falha se algum dos status esperados tiver 0 linhas em
-- fct_orders.

with expected_statuses as (
    select *
    from (values ('delivered'), ('shipped'), ('canceled')) as t(order_status)
),

actual_counts as (
    select order_status, count(*) as row_count
    from {{ ref('fct_orders') }}
    group by 1
)

select
    expected_statuses.order_status,
    coalesce(actual_counts.row_count, 0) as row_count
from expected_statuses
left join actual_counts on expected_statuses.order_status = actual_counts.order_status
where coalesce(actual_counts.row_count, 0) = 0
