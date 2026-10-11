-- Em snap_orders_status, cada order_id deve ter exatamente uma versão vigente
-- (dbt_valid_to is null). Mais de uma indicaria falha na lógica de SCD tipo 2
-- (ex. duas linhas "abertas" pro mesmo pedido). Retorna linhas quando esse
-- invariante é violado (teste falha se houver alguma linha).

select order_id, count(*) as open_versions
from {{ ref('snap_orders_status') }}
where dbt_valid_to is null
group by order_id
having count(*) != 1
