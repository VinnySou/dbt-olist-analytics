with orders as (
    select * from {{ ref('fct_orders') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

delivered as (
    select
        orders.order_id,
        orders.payment_value,
        orders.review_score,
        dates.year,
        dates.month,
        dates.date_key
    from orders
    inner join dates on orders.order_purchase_date_key = dates.date_key
    where orders.order_status = 'delivered'
),

monthly as (
    select
        year,
        month,
        min(date_key) as month_start_date_key,
        count(*) as delivered_orders,
        sum(payment_value) as revenue,
        avg(payment_value) as avg_order_value,
        avg(review_score) as avg_review_score
    from delivered
    group by 1, 2
)

select
    year,
    month,
    month_start_date_key,
    delivered_orders,
    revenue,
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
