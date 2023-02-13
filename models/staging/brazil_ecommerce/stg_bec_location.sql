with 

source as (

    select * from {{ source('src_brazil_ecommerce', 'location')}}
),

bec_location as (

    select
        geolocation_zip_code_prefix as zip_code,
        geolocation_lat as latitude,
        geolocation_lng as longitude,
        geolocation_city as city,
        geolocation_state as state

    from {{ source('src_brazil_ecommerce', 'location')}}
)

select * from bec_location