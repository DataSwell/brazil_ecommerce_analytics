with reviews as (

    select * from {{ ref('bec_stg_reviews')}}
)

select * from reviews