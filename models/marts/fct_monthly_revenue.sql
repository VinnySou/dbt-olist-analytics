with orders as (
    select * from {{ ref('fct_orders') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

delivered_by_month as (
    select
        dates.year,
        dates.month,
        min(dates.date_day) as month_start_date,
        sum(orders.payment_value) as revenue,
        count(*) as delivered_orders,
        avg(orders.review_score) as avg_review_score,
        avg(orders.delivery_time_days) as avg_delivery_time_days
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
    avg_review_score,
    avg_delivery_time_days,
    lag(revenue) over (order by month_start_date) as prior_month_revenue,
    round(
        100.0 * (revenue - lag(revenue) over (order by month_start_date))
        / nullif(lag(revenue) over (order by month_start_date), 0),
        1
    ) as revenue_change_pct
from delivered_by_month
order by month_start_date
