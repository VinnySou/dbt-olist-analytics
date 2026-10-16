{#
    Histórico de status do pedido (SCD tipo 2).

    Estratégia 'check' em vez de 'timestamp' porque o dataset Olist não tem
    uma coluna updated_at em raw_orders — o que muda, de um load pro outro,
    é o próprio order_status (ex.: "shipped" -> "delivered"). O snapshot
    guarda uma linha por versão de order_status, com dbt_valid_from /
    dbt_valid_to marcando o período de validade de cada uma.

    Snapshot roda direto sobre o seed (fonte), não sobre a staging, seguindo
    a prática recomendada do dbt de capturar histórico o mais perto possível
    da fonte.
#}
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
    order_status,
    cast(order_purchase_timestamp as timestamp) as purchased_at
from {{ ref('raw_orders') }}

{% endsnapshot %}
