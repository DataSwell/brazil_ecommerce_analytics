-- For one order can exist multiple payments. This intermediate layer will aggregate the grain from single payments to payments per order.

{% set payment_methods = ['credit_card', 'voucher', 'not_defined', 'boleto', 'debit_card'] %}
 

with payments as (

   select * from {{ ref('stg_bec_payments') }}
),

aggregate_payments_to_order_grain as (

    select
        order_id,
        {% for payment_method in payment_methods -%}
            sum(
                case
                    when payment_type = '{{ payment_method }}' 
                    then amount
                    end
            ) as {{ payment_method }}_amount,
        {%- endfor %}

        sum(amount) as order_total_amount
    
    from payments

    group by order_id
)

select * from aggregate_payments_to_order_grain