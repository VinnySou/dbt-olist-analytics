-- A soma de (price + freight_value) dos itens de um pedido deve bater com o
-- payment_value agregado em fct_orders. Tolerância de 1 centavo para
-- diferenças de arredondamento entre os dois cálculos.
-- Retorna linhas quando esse invariante é violado (teste falha se houver alguma linha).

with items_total as (
    select
        order_id,
        sum(price + freight_value) as items_total_value
    from {{ ref('fct_order_items') }}
    group by 1
)

select
    fct_orders.order_id,
    fct_orders.payment_value,
    items_total.items_total_value,
    abs(fct_orders.payment_value - items_total.items_total_value) as difference
from {{ ref('fct_orders') }}
inner join items_total on fct_orders.order_id = items_total.order_id
where abs(fct_orders.payment_value - items_total.items_total_value) > 0.01
