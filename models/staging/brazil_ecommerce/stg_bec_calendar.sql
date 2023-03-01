with calendar as (

    select 
        *,
        extract(year from date) as year_num,
        concat(cast(daynumofweek as varchar), dayname) as day_num_and_name
    from {{ ref('calendar')}}
)

select * from calendar