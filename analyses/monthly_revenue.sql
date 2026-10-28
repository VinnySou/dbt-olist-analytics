-- Receita mensal (soma de payment_value) para pedidos entregues, com variação % vs. mês anterior.
-- O agregado por mês mora em `fct_monthly_revenue`; esta analysis só adiciona a comparação mês a mês.
with monthly as (
    select * from {{ ref('fct_monthly_revenue') }}
)

select
    year,
    month,
    revenue,
    delivered_orders,
    lag(revenue) over (order by year, month) as prior_month_revenue,
    round(
        100.0 * (revenue - lag(revenue) over (order by year, month))
        / nullif(lag(revenue) over (order by year, month), 0),
        1
    ) as revenue_change_pct
from monthly
order by year, month
