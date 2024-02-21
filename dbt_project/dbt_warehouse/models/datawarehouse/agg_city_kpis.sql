with listings as (
    select *
    from {{ ref('stg_listings') }}
)

, total as (
    select 
        city,
        'Total' as neighbourhood,
        1 as is_total,
        count(*) as total_listings_city,
        count(*) as total_listings,
        -- room_type
        sum(case when room_type = 'Entire home/apt' then 1 else 0 end) as entire_home_apt,
        sum(case when room_type = 'Hotel room' then 1 else 0 end) as hotel_rooms,
        sum(case when room_type = 'Private room' then 1 else 0 end) as private_rooms,
        sum(case when room_type = 'Shared room' then 1 else 0 end) as shared_rooms,
        -- activity
        avg(number_of_reviews_ltm)::int as average_nights_booked,
        avg(price)::int as price_per_night,
        avg(number_of_reviews_ltm)::int * avg(price)::int as average_income,
        -- licenses
        sum(case when license is null or license = 'nan' then 1 else 0 end) as unlicensed,
        sum(case when lower(license) like ('%exempt%') then 1 else 0 end) as exempt,
        sum(case when lower(license) like ('%pending%') then 1 else 0 end) as pending,
        sum(case when license is null then 0
            when license = 'nan' then 0
            when lower(license) like ('%exempt%') then 0
            when lower(license) like ('%pending%') then 0
            else 1 
        end) as licensed,
        -- Short term rentals
        sum(case when minimum_nights <= 30 then 1 else 0 end) as short_term_rentals,
        sum(case when minimum_nights > 30 then 1 else 0 end) as longer_term_rentals,
        -- Multilple listings
        sum(case when calculated_host_listings_count = 1 then 1 else 0 end) as single_listings,
        sum(case when calculated_host_listings_count > 1 then 1 else 0 end) as multiple_listings,
        -- bonus
        sum(case when calculated_host_listings_count > 1 and calculated_host_listings_count < 11 then 1 else 0 end) as listings_2_10,
        sum(case when calculated_host_listings_count > 10 and calculated_host_listings_count < 21 then 1 else 0 end) as listings_10_20,
        sum(case when calculated_host_listings_count > 20 and calculated_host_listings_count < 31 then 1 else 0 end) as listings_20_30,
        sum(case when calculated_host_listings_count > 30 then 1 else 0 end) as listings_30p,
        -- bonus occupancy
        sum(case when availability_365 = 0 then 1 else 0 end) as avilability_0,
        sum(case when availability_365 > 0 and availability_365 < 61 then 1 else 0 end) as avilability_1_60,
        sum(case when availability_365 > 60 and availability_365 < 121 then 1 else 0 end) as avilability_60_120,
        sum(case when availability_365 > 120 and availability_365 < 181 then 1 else 0 end) as avilability_120_180,
        sum(case when availability_365 > 180 and availability_365 < 241 then 1 else 0 end) as avilability_180_240,
        sum(case when availability_365 > 240 then 1 else 0 end) as avilability_240p
    from listings
    group by 1
)

, detail as (
    select 
        l.city,
        l.neighbourhood,
        0 as is_total,
        t.total_listings_city,
        count(*) as total_listings,
        -- room_type
        sum(case when room_type = 'Entire home/apt' then 1 else 0 end) as entire_home_apt,
        sum(case when room_type = 'Hotel room' then 1 else 0 end) as private_rooms,
        sum(case when room_type = 'Private room' then 1 else 0 end) as shared_rooms,
        sum(case when room_type = 'Shared room' then 1 else 0 end) as hotel_rooms,
        -- activity
        avg(number_of_reviews_ltm)::int as average_nights_booked,
        avg(price)::int as price_per_night,
        avg(number_of_reviews_ltm)::int * avg(price)::int as average_income,
        -- licenses
        sum(case when license is null or license = 'nan' then 1 else 0 end) as unlicensed,
        sum(case when lower(license) like ('%exempt%') then 1 else 0 end) as exempt,
        sum(case when lower(license) like ('%pending%') then 1 else 0 end) as pending,
        sum(case when license is null then 0
            when license = 'nan' then 0
            when lower(license) like ('%exempt%') then 0
            when lower(license) like ('%pending%') then 0
            else 1 
        end) as licensed,
        -- Short term rentals
        sum(case when minimum_nights <= 30 then 1 else 0 end) as short_term_rentals,
        sum(case when minimum_nights > 30 then 1 else 0 end) as longer_term_rentals,
        -- single listings
        sum(case when calculated_host_listings_count = 1 then 1 else 0 end) as single_listings,
        sum(case when calculated_host_listings_count > 1 then 1 else 0 end) as multiple_listings,
        -- bonus
        sum(case when calculated_host_listings_count > 1 and calculated_host_listings_count < 11 then 1 else 0 end) as listings_2_10,
        sum(case when calculated_host_listings_count > 10 and calculated_host_listings_count < 21 then 1 else 0 end) as listings_10_20,
        sum(case when calculated_host_listings_count > 20 and calculated_host_listings_count < 31 then 1 else 0 end) as listings_20_30,
        sum(case when calculated_host_listings_count > 30 then 1 else 0 end) as listings_30p,
        -- bonus occupancy
        sum(case when availability_365 = 0 then 1 else 0 end) as avilability_0,
        sum(case when availability_365 > 0 and availability_365 < 61 then 1 else 0 end) as avilability_1_60,
        sum(case when availability_365 > 60 and availability_365 < 121 then 1 else 0 end) as avilability_60_120,
        sum(case when availability_365 > 120 and availability_365 < 181 then 1 else 0 end) as avilability_120_180,
        sum(case when availability_365 > 180 and availability_365 < 241 then 1 else 0 end) as avilability_180_240,
        sum(case when availability_365 > 240 then 1 else 0 end) as avilability_240p
    from listings l
    inner join total t on l.city = t.city
    group by 1,2,4
)

, unioned as (
    select * from total
    union all
    select * from detail
)

select 
    *,
    -- proportions
    -- total listings
    round((total_listings * 1.0 / total_listings_city * 1.0) * 100, 1) as listing_proportion,
    -- room type
    round((entire_home_apt * 1.0 / total_listings * 1.0) * 100, 1) as entire_home_apt_proportion,
    round((private_rooms * 1.0 / total_listings * 1.0) * 100, 1) as private_rooms_proportion,
    round((shared_rooms * 1.0 / total_listings * 1.0) * 100, 1) as shared_rooms_proportion,
    round((hotel_rooms * 1.0 / total_listings * 1.0) * 100, 1) as hotel_rooms_proportion,
    -- licenses
    round((unlicensed * 1.0 / total_listings * 1.0) * 100, 1) as unlicensed_proportion,
    round((exempt * 1.0 / total_listings * 1.0) * 100, 1) as exempt_proportion,
    round((pending * 1.0 / total_listings * 1.0) * 100, 1) as pending_proportion,
    round((licensed * 1.0 / total_listings * 1.0) * 100, 1) as licensed_proportion,
    -- short term rentals
    round((short_term_rentals * 1.0 / total_listings * 1.0) * 100, 1) as short_term_rentals_proportion,
    round((longer_term_rentals * 1.0 / total_listings * 1.0) * 100, 1) as longer_term_rentals_proportion,
    -- single listings
    round((single_listings * 1.0 / total_listings * 1.0) * 100, 1) as single_listings_proportion,
    round((multiple_listings * 1.0 / total_listings * 1.0) * 100, 1) as multiple_listings_proportion
from unioned
order by city, is_total desc, neighbourhood