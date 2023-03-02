with order_items as (

    select * from {{ ref('bec_stg_order_items')}}
),

products as (

    select
        p.product_id,
        pt.category_english as product_category
    from {{ ref('bec_stg_products')}} p
    left join {{ ref('bec_stg_product_cat_translate')}} pt on p.product_category = pt.category_portuguese
),

sellers as (

    select * from {{ ref('bec_stg_sellers')}}
),

customers as (

    select * from {{ ref('bec_stg_customers')}}
),

orders as (

    select * from {{ ref('bec_stg_orders')}}
),

final as (

    select 
        p.product_id,
        p.product_category,
        oi.price,
        oi.shipping_date,
        o.order_status,
        s.seller_id,
        s.seller_city,
        s.seller_state,
        c.customer_id,
        c.customer_city,
        c.customer_state

    from order_items oi

    left join products p on oi.product_id = p.product_id
    left join sellers s on oi.seller_id = s.seller_id
    left join orders o on oi.order_id = o.order_id
    left join customers c on o.customer_id = c.customer_id

)

select * from final
