with order_items as (
    select * from {{ ref('stg_olist__order_items') }}
),

orders as (
    select order_id, purchased_at from {{ ref('stg_olist__orders') }}
),

joined as (
    select
        order_items.order_id,
        order_items.order_item_id,
        order_items.product_id,
        order_items.seller_id,
        cast(strftime(orders.purchased_at, '%Y%m%d') as integer) as order_purchase_date_key,
        order_items.price,
        order_items.freight_value
    from order_items
    left join orders
        on order_items.order_id = orders.order_id
)

select * from joined
