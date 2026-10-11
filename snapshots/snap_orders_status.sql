{#
    SCD tipo 2 do status do pedido (stg_olist__orders.order_status).

    O dataset da Olist não expõe uma tabela de histórico de status - só o status
    atual por pedido. Por isso usamos strategy='check' (não há coluna de
    updated_at confiável pra usar strategy='timestamp'): a cada `dbt snapshot`,
    dbt compara order_status com a última versão guardada e, se mudou, fecha a
    linha antiga (dbt_valid_to) e insere uma nova (dbt_valid_from). Isso só gera
    histórico de fato ao longo de múltiplos runs - útil sobretudo em CI
    agendado, onde a origem muda entre execuções.
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
    purchased_at
from {{ ref('stg_olist__orders') }}

{% endsnapshot %}
