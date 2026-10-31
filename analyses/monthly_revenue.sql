-- Receita mensal (soma de payment_value) para pedidos entregues, com variação % vs. mês anterior.
-- O group by mora em models/marts/fct_monthly_revenue.sql; esta analysis só expõe o número.
select
    year,
    month,
    revenue,
    delivered_order_count as delivered_orders,
    prior_month_revenue,
    revenue_change_pct
from {{ ref('fct_monthly_revenue') }}
order by year, month
