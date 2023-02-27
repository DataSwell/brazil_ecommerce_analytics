with orders as (

    select * from {{ ref('stg_bec_orders')}}
),


order_payments as (

    select * from {{ ref('int_bec_payments_pivoted_to_orders')}}
),


orders_and_order_payments_joined as (

    select
        o.*,
        coalesce(op.order_total_amount, 0) as order_amount,
        case 
            when o.customer_delivery_date <= o.estimated_delivery_date 
            then 'In Time'
            else 'Delayed'
            end as delivered_on_time
    from orders o

    left join order_payments op on o.order_id = op.order_id
)

select * from orders_and_order_payments_joined