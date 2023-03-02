with source as (

    select * from {{ source('src_brazil_ecommerce', 'order_items')}}
),

bec_order_items as (

    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        cast(shipping_limit_date as date) as shipping_date,
        shipping_limit_date as shipping_timestamp,
        price,
        freight_value

    from source
)

select * from bec_order_items