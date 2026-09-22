with products as (
    select * from {{ ref('stg_olist__products') }}
),

sized as (
    select
        product_id,
        category,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm,
        product_length_cm * product_height_cm * product_width_cm as product_volume_cm3
    from products
)

select
    product_id,
    category,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    product_volume_cm3,
    case
        when product_volume_cm3 is null then 'unknown'
        when product_volume_cm3 < 30000 then 'pequeno'
        when product_volume_cm3 < 100000 then 'medio'
        else 'grande'
    end as product_size_category
from sized
