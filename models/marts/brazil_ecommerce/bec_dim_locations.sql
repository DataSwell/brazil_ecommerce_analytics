with location as (

    select * from {{ ref('stg_bec_location')}}
)

select * from location