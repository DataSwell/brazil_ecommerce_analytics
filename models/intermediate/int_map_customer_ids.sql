/*
The customer table includes a customer_id which is the reference to the orders table.
It also includes a unique_customer_id which represent one customer. If a customer has placed more then one order, there will be multiple rows.
Each with a different customer_id but al the same unique_customer_ id. 

Because of the additional key (customer_id) to the order table instead of using the unique_orer_id we need to map the aggregated order values to the unique _customer_id.
*/

with customer_payments as (

    select 
        cu.customer_unique_id,
        count(order_id) as number_of_orders,
        min(order_amount) as smallest_order_amount,
        max(order_amount) as highest_order_amount,
        avg(order_amount) as average_order_amount,
        sum(order_amount) as total_amount 
    
    from {{ ref('bec_fct_orders')}} fo

    left join {{ ref('stg_bec_customers') }} cu on fo.customer_id = cu.customer_id

    group by customer_unique_id

)

select * from customer_payments