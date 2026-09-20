with source as (
    select * from {{ ref('raw_reviews') }}
)

select
    review_id,
    order_id,
    review_score
from source
