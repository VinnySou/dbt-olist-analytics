{% snapshot snapshot_olist__orders_status %}

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
    purchased_at,
    approved_at,
    delivered_at,
    estimated_delivery_at
from {{ ref('stg_olist__orders') }}

{% endsnapshot %}
