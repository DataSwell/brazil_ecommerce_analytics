with products as (

    select         
        p.*,
        pt.category_english
    from {{ ref('bec_stg_products')}} p

    left join {{ ref('bec_stg_product_cat_translate')}} pt on p.product_category = pt.category_portuguese
)

select * from products