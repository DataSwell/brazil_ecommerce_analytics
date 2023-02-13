with

source as (

    select * from {{ source('src_brazil_ecommerce', 'customers')}}
),

bec_customers as (

    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix as customer_zip_code,
        customer_city,
        customer_state
    from {{ source('src_brazil_ecommerce', 'customers')}}
)

select * from bec_customers