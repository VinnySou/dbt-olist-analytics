-- Receita mensal (pedidos delivered) com variação % vs. mês anterior.
-- Lógica de agregação mora em models/marts/fct_monthly_revenue.sql; esta análise só expõe o resultado.
select
    year,
    month,
    revenue,
    delivered_orders,
    prior_month_revenue,
    revenue_change_pct
from {{ ref('fct_monthly_revenue') }}
order by year, month
