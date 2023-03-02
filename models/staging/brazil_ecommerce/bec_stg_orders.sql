with 

source as (

    select * from {{ source('src_brazil_ecommerce', 'orders')}}
),

bec_orders as (

    select
        order_id,
        customer_id,
        order_status,
        cast(order_purchase_timestamp as date) as order_date,
        order_purchase_timestamp as order_timestamp,
        cast(order_approved_at as date) as payment_date,
        order_approved_at as payment_timestamp,
        cast(order_delivered_carrier_date as date) as carrier_delivery_date,
        order_delivered_carrier_date as carrier_delivery_timestamp,
        cast(order_delivered_customer_date as date) as customer_delivery_date,
        order_delivered_customer_date as customer_delivery_timestamp,
        cast(order_estimated_delivery_date as date) as estimated_delivery_date,
        order_estimated_delivery_date as estimated_delivery_timestamp
    
    from source
)

select * from bec_orders