{% test min_row_count(model, min_count) %}

with validation as (

    select count(*) as row_count
    from {{ model }}

)

select *
from validation
where row_count < {{ min_count }}

{% endtest %}
