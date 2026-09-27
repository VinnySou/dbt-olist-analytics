-- Curva ABC de categoria de produto por receita (price + freight_value):
-- A = categorias que somam até 80% da receita acumulada, B = até 95%, C = o restante.
with items as (
    select * from {{ ref('fct_order_items') }}
),

products as (
    select * from {{ ref('dim_products') }}
),

by_category as (
    select
        products.category,
        sum(items.price + items.freight_value) as revenue
    from items
    inner join products on items.product_id = products.product_id
    group by 1
),

ranked as (
    select
        category,
        revenue,
        sum(revenue) over () as total_revenue,
        sum(revenue) over (order by revenue desc rows between unbounded preceding and current row) as cumulative_revenue
    from by_category
)

select
    category,
    revenue,
    round(100.0 * revenue / total_revenue, 2) as revenue_share_pct,
    round(100.0 * cumulative_revenue / total_revenue, 2) as cumulative_revenue_share_pct,
    case
        when cumulative_revenue / total_revenue <= 0.8 then 'A'
        when cumulative_revenue / total_revenue <= 0.95 then 'B'
        else 'C'
    end as abc_class
from ranked
order by revenue desc
