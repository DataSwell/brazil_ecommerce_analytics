with order_items as (

    select * from {{ ref('bec_stg_order_items')}}
)

select * from order_items