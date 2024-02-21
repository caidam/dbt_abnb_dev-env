with listings as (
    select *
    from {{ ref('stg_listings') }}
)

select
    city_id,
    country,
    state,
    city,
    avg(latitude) as city_avg_latitude,
    avg(longitude) as city_avg_longitude
from listings
group by 1,2,3,4
order by state