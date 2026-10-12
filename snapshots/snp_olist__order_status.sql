{% snapshot snp_olist__order_status %}

{{
    config(
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
