-- Nenhum pedido pode ter valor de pagamento, preço de item ou frete negativo.
-- Retorna linhas quando esse invariante é violado (teste falha se houver alguma linha).

select order_id, 'fct_orders.payment_value' as source_column, payment_value as value
from {{ ref('fct_orders') }}
where payment_value < 0

union all

select order_id, 'fct_order_items.price' as source_column, price as value
from {{ ref('fct_order_items') }}
where price < 0

union all

select order_id, 'fct_order_items.freight_value' as source_column, freight_value as value
from {{ ref('fct_order_items') }}
where freight_value < 0
