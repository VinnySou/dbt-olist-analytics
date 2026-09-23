with spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('" ~ var('dim_date_start_date') ~ "' as date)",
        end_date="cast('" ~ var('dim_date_end_date') ~ "' as date)"
    ) }}
),

renamed as (
    select
        cast(date_day as date) as date_day
    from spine
)

select
    date_day,
    cast(strftime(date_day, '%Y%m%d') as integer) as date_key,
    extract(year from date_day) as year,
    extract(quarter from date_day) as quarter,
    extract(month from date_day) as month,
    extract(day from date_day) as day_of_month,
    extract(dow from date_day) as day_of_week,
    strftime(date_day, '%A') as day_name,
    strftime(date_day, '%B') as month_name,
    extract(dow from date_day) in (0, 6) as is_weekend
from renamed
