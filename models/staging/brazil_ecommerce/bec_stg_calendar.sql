with calendar as (

    select 
        *,
        extract(year from date) as year_num,
        concat(daynumofweek::varchar, dayname) as day_num_and_name
    from {{ ref('calendar')}}
)

select * from calendar