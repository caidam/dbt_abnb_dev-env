with raw_listings as (

    select * 
    from {{ source( "raw_db", "listings" ) }}
    where country is not null

)

select
*, 
md5(country || state || city) as city_id,
md5( coalesce(neighbourhood, city) || city || country || state) as neighbourhood_id
from raw_listings