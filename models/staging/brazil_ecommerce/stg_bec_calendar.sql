with source as (

    select 
        *,
        extract(year from date) as year_num
    from {{ source('src_brazil_ecommerce', 'calendar')}}
)

select * from source