with sellers as (

    select * from {{ ref('bec_stg_sellers')}}
)

select * from sellers