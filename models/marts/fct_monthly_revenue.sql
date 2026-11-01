with orders as (
    select * from {{ ref('fct_orders') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

delivered as (
    select
        dates.date_key,
        dates.year,
        dates.quarter,
        dates.month,
        orders.payment_value,
        orders.review_score
    from orders
    inner join dates on orders.order_purchase_date_key = dates.date_key
    where orders.order_status = 'delivered'
),

monthly as (
    select
        year,
        quarter,
        month,
        sum(payment_value) as revenue,
        count(*) as delivered_orders,
        avg(payment_value) as avg_order_value,
        avg(review_score) as avg_review_score
    from delivered
    group by 1, 2, 3
)

select
    year,
    quarter,
    month,
    cast(year * 10000 + month * 100 + 1 as integer) as month_start_date_key,
    revenue,
    delivered_orders,
    avg_order_value,
    avg_review_score,
    lag(revenue) over (order by year, month) as prior_month_revenue,
    round(
        100.0 * (revenue - lag(revenue) over (order by year, month))
        / nullif(lag(revenue) over (order by year, month), 0),
        1
    ) as revenue_change_pct
from monthly
order by year, month
