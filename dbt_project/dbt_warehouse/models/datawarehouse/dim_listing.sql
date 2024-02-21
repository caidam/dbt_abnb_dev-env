with listings as (
    select *
    from {{ ref('stg_listings') }}
)
 select
    id,
    name,
    host_id,
    host_name,
    neighbourhood,
    city,
    latitude,
    longitude,
    room_type,
    price,
    minimum_nights,
    number_of_reviews,
    last_review,
    reviews_per_month,
    calculated_host_listings_count,
    availability_365,
    number_of_reviews_ltm,
    license,
    neighbourhood_id,
    city_id
 from listings