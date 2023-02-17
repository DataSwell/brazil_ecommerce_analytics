/* sequence of the order timestamps must be:
order_date < payment_date AND carrier_delivery_date < customer_delivery_date
it is possible, that the customer pays after reveiving the products
*/

with orders as (
    select * from {{ ref('stg_bec_orders')}}
)

select *
from orders
where 
    order_date > payment_date or
    carrier_delivery_date > customer_delivery_date
