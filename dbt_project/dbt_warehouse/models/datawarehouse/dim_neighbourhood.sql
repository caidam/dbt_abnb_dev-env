with listings as (
    select *
    from {{ ref('stg_listings') }}
)

select
    neighbourhood_id,
    neighbourhood,
    neighbourhood_group,
    city_id,
    avg(latitude) as neighbourhood_avg_latitude,
    avg(longitude) as neighbourhood_avg_longitude
from listings
group by 1,2,3,4