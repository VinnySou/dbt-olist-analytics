with orders as (
    select * from {{ ref('stg_olist__orders') }}
),

payments_agg as (
    select
        order_id,
        sum(payment_value) as payment_value,
        max(payment_installments) as payment_installments
    from {{ ref('stg_olist__payments') }}
    group by 1
),

primary_payment as (
    select
        order_id,
        payment_type
    from {{ ref('stg_olist__payments') }}
    qualify row_number() over (partition by order_id order by payment_sequential) = 1
),

reviews_agg as (
    select
        order_id,
        avg(review_score) as review_score
    from {{ ref('stg_olist__reviews') }}
    group by 1
),

joined as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_status,
        cast(strftime(orders.purchased_at, '%Y%m%d') as integer) as order_purchase_date_key,
        orders.purchased_at,
        orders.approved_at,
        orders.delivered_at,
        orders.estimated_delivery_at,
        payments_agg.payment_value,
        payments_agg.payment_installments,
        primary_payment.payment_type,
        reviews_agg.review_score,
        case
            when orders.order_status = 'delivered'
                then date_diff('day', orders.purchased_at, orders.delivered_at)
        end as delivery_time_days,
        case
            when orders.order_status = 'delivered'
                then date_diff('day', orders.estimated_delivery_at, orders.delivered_at)
        end as delivery_delay_days
    from orders
    left join payments_agg on orders.order_id = payments_agg.order_id
    left join primary_payment on orders.order_id = primary_payment.order_id
    left join reviews_agg on orders.order_id = reviews_agg.order_id
)

select * from joined
