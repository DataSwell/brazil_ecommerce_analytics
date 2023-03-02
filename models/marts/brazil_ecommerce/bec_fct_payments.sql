with payments as (

    select * from {{ ref('bec_stg_payments')}}
)

select * from payments