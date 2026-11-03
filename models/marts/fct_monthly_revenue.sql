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
        date_trunc('month', dates.date_day) as month_start_date,
        orders.payment_value
    from orders
    inner join dates on orders.order_purchase_date_key = dates.date_key
    where orders.order_status = 'delivered'
)

select
    year,
    month,
    month_start_date,
    sum(payment_value) as revenue,
    count(*) as delivered_orders
from delivered
group by 1, 2, 3
order by year, month
