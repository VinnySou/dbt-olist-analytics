-- Taxa de atraso (delivery_delay_days > 0) por estado do cliente, só pedidos entregues.
with orders as (
    select * from {{ ref('fct_orders') }}
),

customers as (
    select * from {{ ref('dim_customers') }}
),

delivered as (
    select
        customers.state,
        orders.delivery_delay_days,
        case when orders.delivery_delay_days > 0 then 1 else 0 end as is_delayed
    from orders
    inner join customers on orders.customer_id = customers.customer_id
    where orders.order_status = 'delivered'
)

select
    state,
    count(*) as delivered_orders,
    sum(is_delayed) as delayed_orders,
    round(100.0 * sum(is_delayed) / count(*), 1) as delay_rate_pct,
    round(avg(delivery_delay_days), 1) as avg_delay_days
from delivered
group by 1
order by delay_rate_pct desc
