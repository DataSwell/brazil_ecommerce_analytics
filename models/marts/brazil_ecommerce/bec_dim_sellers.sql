with sellers as (

    select * from {{ ref('stg_bec_sellers')}}
)

select * from sellers