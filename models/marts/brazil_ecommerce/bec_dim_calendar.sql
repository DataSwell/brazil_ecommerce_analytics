with calendar as (

    select * from {{ ref('bec_stg_calendar')}}
)

select * from calendar