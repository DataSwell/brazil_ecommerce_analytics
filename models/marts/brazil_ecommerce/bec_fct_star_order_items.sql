with order_items as (

    select * from {{ ref('stg_bec_order_items')}}
)

select * from order_items