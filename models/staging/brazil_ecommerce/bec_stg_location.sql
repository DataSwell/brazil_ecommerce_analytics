with 

source as (

    select * from {{ source('src_brazil_ecommerce', 'location')}}
),

bec_location as (

    select
        -- concat latitude & longitude to unique surrogate key
        concat(cast(geolocation_lat as varchar(50)), cast(geolocation_lng as varchar(50))) as location_id,
        geolocation_zip_code_prefix as zip_code,
        geolocation_lat as latitude,
        geolocation_lng as longitude,
        geolocation_city as city,
        geolocation_state as state

    from {{ source('src_brazil_ecommerce', 'location')}}
)

select * from bec_location