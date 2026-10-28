with orders as (
    select * from {{ ref('fct_orders') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

delivered as (
    select
        dates.year,
        dates.month,
        orders.payment_value
    from orders
    inner join dates on orders.order_purchase_date_key = dates.date_key
    where orders.order_status = 'delivered'
)

select
    year,
    month,
    make_date(year, month, 1) as month_start_date,
    sum(payment_value) as revenue,
    count(*) as delivered_orders,
    round(sum(payment_value) / count(*), 2) as avg_order_value
from delivered
group by 1, 2
order by 1, 2
