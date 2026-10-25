-- Receita mensal (soma de payment_value) para pedidos entregues, com variação % vs. mês anterior.
-- A lógica de agregação vive em fct_monthly_revenue; esta analysis só expõe a pergunta de negócio.
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
