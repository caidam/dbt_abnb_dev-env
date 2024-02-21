with listings as (
    select *
    from {{ source('raw_db', 'listings') }}
)


select
    host_id,
    host_name,
    count(distinct id) as host_total_listings_count,
    count(distinct city) as host_nb_cities,
    count(distinct country) as host_nb_countries
from listings
group by 1,2

