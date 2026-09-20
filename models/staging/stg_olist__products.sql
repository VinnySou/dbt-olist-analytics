with source as (
    select * from {{ ref('raw_products') }}
),

translation as (
    select * from {{ ref('raw_category_translation') }}
)

select
    source.product_id,
    coalesce(translation.product_category_name_english, source.product_category_name, 'unknown') as category,
    source.product_weight_g,
    source.product_length_cm,
    source.product_height_cm,
    source.product_width_cm
from source
left join translation
    on source.product_category_name = translation.product_category_name
