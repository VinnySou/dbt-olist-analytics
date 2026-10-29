with orders as (
    select * from {{ ref('fct_orders') }}
    where order_status = 'delivered'
),

dates as (
    select * from {{ ref('dim_date') }}
),

monthly as (
    select
        dates.year,
        dates.month,
        date_trunc('month', dates.date_day) as month_start_date,
        sum(orders.payment_value) as revenue,
        count(*) as delivered_orders
    from orders
    inner join dates on orders.order_purchase_date_key = dates.date_key
    group by 1, 2, 3
)

select
    cast(year * 100 + month as integer) as month_key,
    month_start_date,
    year,
    month,
    revenue,
    delivered_orders
from monthly
