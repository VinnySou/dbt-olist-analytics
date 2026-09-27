-- Receita mensal (soma de payment_value) para pedidos entregues, com variação % vs. mês anterior.
with orders as (
    select * from {{ ref('fct_orders') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

monthly as (
    select
        dates.year,
        dates.month,
        sum(orders.payment_value) as revenue,
        count(*) as delivered_orders
    from orders
    inner join dates on orders.order_purchase_date_key = dates.date_key
    where orders.order_status = 'delivered'
    group by 1, 2
)

select
    year,
    month,
    revenue,
    delivered_orders,
    lag(revenue) over (order by year, month) as prior_month_revenue,
    round(
        100.0 * (revenue - lag(revenue) over (order by year, month))
        / nullif(lag(revenue) over (order by year, month), 0),
        1
    ) as revenue_change_pct
from monthly
order by year, month
