with reviews as (

    select * from {{ ref('stg_bec_reviews')}}
)

select * from reviews