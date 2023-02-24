-- Wide table with all the nessecary information about customers

with customers as (

    select * from {{ ref('stg_bec_customers')}}
),

with orders as (

    select * from {{ ref('stg_bec_orders')}}
),

with payments as (

    select * from {{ ref('stg_bec_payments')}}
),


customer_orders_payments as (

    select 
        customer_id,
        count(order_id) as number_of_orders,
        
    from orders o
    left join payments p using (order_id)
)

select * from customer_oder_payments