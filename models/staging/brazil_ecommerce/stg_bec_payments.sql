with 

source as (

    select * from {{ source('src_brazil_ecommerce', 'payments')}}
),

bec_payments as (

    select 
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value as amount

    from {{ source('src_brazil_ecommerce', 'payments')}}
)

select * from bec_payments