-- Receita mensal para pedidos entregues, com variação % vs. mês anterior.
-- O cálculo em si mora em models/marts/fct_monthly_revenue.sql; esta analysis só expõe o resultado.
select
    year,
    month,
    revenue,
    delivered_orders,
    avg_delivery_time_days,
    avg_delivery_delay_days,
    prior_month_revenue,
    revenue_change_pct
from {{ ref('fct_monthly_revenue') }}
order by year, month
