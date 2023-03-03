with order_items as (

    select * from {{ ref('bec_stg_order_items')}}
)

select
    concat(order_id, cast(order_item_id as varchar(2))) as total_id,
    count(total_id)
from order_items
group by total_id
having count(total_id) > 1
