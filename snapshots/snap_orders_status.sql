{#
    Histórico de mudança de order_status (SCD tipo 2), direto da fonte raw —
    por convenção do dbt, snapshot captura o dado como ele chega, antes de
    qualquer transformação da staging.

    Os seeds deste projeto são estáticos (gerados uma vez por
    scripts/generate_seed_data.py), então rodar `dbt snapshot` em sequência
    sobre o mesmo seed não vai mostrar uma linha nova por si só. Pra ver o
    SCD2 funcionando de ponta a ponta:

        DBT_PROFILES_DIR=. dbt snapshot                 # registra o estado atual
        # edite order_status de algum pedido em seeds/raw_orders.csv
        DBT_PROFILES_DIR=. dbt seed --select raw_orders
        DBT_PROFILES_DIR=. dbt snapshot                  # fecha dbt_valid_to da versão antiga e abre uma nova
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
    order_status
from {{ ref('raw_orders') }}

{% endsnapshot %}
