with 

source as (

    select * from {{ source('src_brazil_ecommerce', 'orders')}}
),

bec_orders as (

    select
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp as order_purchase,
        order_approved_at as order_approved,
        order_delivered_carrier_date as carrier_delivery_date,
        order_delivered_customer_date as customer_delivery_date,
        order_estimated_delivery_date as estimated_delivery_date
    
    from {{ source('src_brazil_ecommerce', 'orders')}}
)

select * from bec_orders