-- Receita mensal: a agregação agora vive em models/marts/fct_monthly_revenue.sql.
-- Este arquivo só documenta a consulta de negócio (atalho sem repetir o group by).

select
    year,
    month,
    revenue,
    delivered_orders,
    prior_month_revenue,
    revenue_change_pct
from {{ ref('fct_monthly_revenue') }}
order by year, month
