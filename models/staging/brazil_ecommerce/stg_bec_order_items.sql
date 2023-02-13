with 

source as (

    select * from {{ source('src_brazil_ecommerce', 'order_items')}}
),

bec_order_items as (

    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date as shipping_date,
        price,
        freight_value

    from {{ source('src_brazil_ecommerce', 'order_items')}}
)

select * from bec_order_items