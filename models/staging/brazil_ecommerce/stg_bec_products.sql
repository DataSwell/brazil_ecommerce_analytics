with 

source as (

    select * from {{ source('src_brazil_ecommerce', 'products')}}
),

bec_products as (

    select
        product_id,
        product_category_name as product_category,
        product_name_lenght,
        product_description_lenght,
        product_photos_qty as photos_quantity,
        product_weight_g as weight_gr,
        product_length_cm as length_cm,
        product_height_cm as height_cm,
        product_width_cm as product_width_cm
    
    from {{ source('src_brazil_ecommerce', 'products')}}
)

select * from bec_products