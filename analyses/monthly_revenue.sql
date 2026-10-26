-- Receita mensal (soma de payment_value) para pedidos entregues, com variação % vs. mês anterior.
-- A agregação em si mora em models/marts/fct_monthly_revenue.sql; esta analysis só expõe a série.
select
    year,
    month,
    revenue,
    delivered_orders,
    avg_order_value,
    prior_month_revenue,
    revenue_change_pct
from {{ ref('fct_monthly_revenue') }}
order by year, month
