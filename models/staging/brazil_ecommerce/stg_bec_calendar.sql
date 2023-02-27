with calendar as (

    select 
        *,
        extract(year from date) as year_num
    from {{ ref('calendar')}}
)

select * from calendar