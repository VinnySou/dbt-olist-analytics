{% snapshot snapshot_orders_status %}

{{
    config(
        target_schema='snapshots',
        unique_key='order_id',
        strategy='check',
        check_cols=['order_status'],
    )
}}

select
    order_id,
    customer_id,
    order_status,
    cast(order_approved_at as timestamp) as order_approved_at,
    cast(order_delivered_customer_date as timestamp) as order_delivered_customer_date
from {{ ref('raw_orders') }}

{% endsnapshot %}
