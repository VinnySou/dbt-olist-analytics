with orders as (
    select * from {{ ref('fct_orders') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

delivered_orders_by_month as (
    select
        date_trunc('month', dates.date_day) as month_start_date,
        dates.year,
        dates.month,
        orders.payment_value,
        orders.delivery_time_days,
        orders.delivery_delay_days
    from orders
    inner join dates on orders.order_purchase_date_key = dates.date_key
    where orders.order_status = 'delivered'
),

monthly as (
    select
        month_start_date,
        year,
        month,
        count(*) as delivered_orders,
        sum(payment_value) as revenue,
        avg(delivery_time_days) as avg_delivery_time_days,
        avg(delivery_delay_days) as avg_delivery_delay_days
    from delivered_orders_by_month
    group by 1, 2, 3
)

select
    month_start_date,
    year,
    month,
    revenue,
    delivered_orders,
    avg_delivery_time_days,
    avg_delivery_delay_days,
    lag(revenue) over (order by month_start_date) as prior_month_revenue,
    round(
        100.0 * (revenue - lag(revenue) over (order by month_start_date))
        / nullif(lag(revenue) over (order by month_start_date), 0),
        1
    ) as revenue_change_pct
from monthly
order by month_start_date
