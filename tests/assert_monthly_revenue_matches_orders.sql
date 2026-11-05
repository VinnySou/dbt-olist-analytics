-- A soma de revenue em fct_monthly_revenue deve bater com a soma de payment_value
-- dos pedidos delivered em fct_orders (mesmo total, só que agregado por mês).
-- Retorna uma linha quando esse invariante é violado (teste falha se houver alguma linha).

with monthly_total as (
    select sum(revenue) as total_revenue
    from {{ ref('fct_monthly_revenue') }}
),

orders_total as (
    select sum(payment_value) as total_revenue
    from {{ ref('fct_orders') }}
    where order_status = 'delivered'
)

select
    monthly_total.total_revenue as monthly_revenue_total,
    orders_total.total_revenue as orders_revenue_total,
    abs(monthly_total.total_revenue - orders_total.total_revenue) as difference
from monthly_total
cross join orders_total
where abs(monthly_total.total_revenue - orders_total.total_revenue) > 0.01
