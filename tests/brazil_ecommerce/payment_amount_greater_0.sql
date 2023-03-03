with payments as (

    select * from {{ ref('bec_stg_payments')}}
)

select
    order_id,
    sum(amount) as total_amount
from payments
group by order_id
having total_amount < 0