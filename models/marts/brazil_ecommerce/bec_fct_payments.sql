with payments as (

    select * from {{ ref('stg_bec_payments')}}
)

select * from payments