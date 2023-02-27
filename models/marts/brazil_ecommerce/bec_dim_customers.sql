with customers as (

    select * from {{ ref('stg_bec_customers')}}
),


customer_payments as (

    select * from {{ ref('int_map_customer_ids')}} 

),


final as (

    select 
        cu.customer_id,
        cu.customer_unique_id,
        cu.customer_city,
        cu.customer_state,
        cp.number_of_orders,
        cp.total_amount,
        cp.smallest_order_amount,
        cp.highest_order_amount,
        cp.average_order_amount
        
    from customer_payments cp

    left join customers cu on cu.customer_unique_id = cp.customer_unique_id
)

select * from final