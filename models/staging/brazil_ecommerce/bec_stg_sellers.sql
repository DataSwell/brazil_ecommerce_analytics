with source as (

    select * from {{ source('src_brazil_ecommerce', 'sellers')}}
),

bec_sellers as (

    select 
        seller_id,
        seller_zip_code_prefix as seller_zip_code,
        seller_city,
        seller_state

    from source
)

select * from bec_sellers