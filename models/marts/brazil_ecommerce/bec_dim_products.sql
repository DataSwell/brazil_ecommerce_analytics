with products as (

    select         
        p.*,
        pt.category_english
    from {{ ref('stg_bec_products')}} p

    left join {{ ref('stg_bec_product_cat_translate')}} pt on p.product_category = pt.category_portuguese
)

select * from products