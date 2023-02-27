with calendar as (

    select * from {{ ref('stg_bec_calendar')}}
)

select * from calendar