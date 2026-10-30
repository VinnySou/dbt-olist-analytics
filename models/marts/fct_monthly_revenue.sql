-- Grão: ano + mês. Agrega fct_orders (pedidos delivered) via dim_date, pra centralizar
-- o group by que analyses/monthly_revenue.sql e qualquer análise futura por mês precisam repetir.
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
        min(dates.date_day) as month_start_date,
        sum(orders.payment_value) as revenue,
        count(*) as delivered_orders,
        avg(orders.review_score) as avg_review_score
    from orders
    inner join dates on orders.order_purchase_date_key = dates.date_key
    where orders.order_status = 'delivered'
    group by 1, 2
)

select
    year,
    month,
    month_start_date,
    revenue,
    delivered_orders,
    round(revenue / delivered_orders, 2) as avg_order_value,
    avg_review_score,
    lag(revenue) over (order by year, month) as prior_month_revenue,
    round(
        100.0 * (revenue - lag(revenue) over (order by year, month))
        / nullif(lag(revenue) over (order by year, month), 0),
        1
    ) as revenue_change_pct
from monthly
order by year, month
