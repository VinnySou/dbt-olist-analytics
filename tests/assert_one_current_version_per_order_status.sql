-- Em um snapshot SCD tipo 2, cada order_id deve ter exatamente uma versão vigente
-- (dbt_valid_to nulo) em snap_orders_status. Retorna linhas quando esse invariante
-- é violado (teste falha se houver alguma linha).

select
    order_id,
    count(*) as current_versions
from {{ ref('snap_orders_status') }}
where dbt_valid_to is null
group by order_id
having count(*) != 1
