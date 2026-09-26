-- Nenhum pedido entregue pode ter data de entrega anterior à data de compra.
-- Retorna linhas quando esse invariante é violado (teste falha se houver alguma linha).

select
    order_id,
    purchased_at,
    delivered_at
from {{ ref('fct_orders') }}
where delivered_at is not null
    and delivered_at < purchased_at
