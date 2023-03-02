with location as (

    select * from {{ ref('bec_stg_location')}}
)

select * from location