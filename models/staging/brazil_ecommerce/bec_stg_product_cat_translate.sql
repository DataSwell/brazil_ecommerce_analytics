with

source as (

    select * from {{ source('src_brazil_ecommerce', 'product_cat_translate')}}
),

bec_prod_cat_transate as (

    select
        category_name_portuguese as category_portuguese,
        category_name_english as category_english
    
    from {{ source('src_brazil_ecommerce', 'product_cat_translate')}}
)

select * from bec_prod_cat_transate