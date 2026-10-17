{% snapshot snap_orders_status %}

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
    order_status
from {{ ref('raw_orders') }}

{% endsnapshot %}
