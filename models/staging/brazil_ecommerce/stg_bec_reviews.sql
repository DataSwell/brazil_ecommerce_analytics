with source as (

    select * from {{ source('src_brazil_ecommerce', 'reviews')}}
),

bec_reviews as (

    select
        -- for some orders there a duplicated reviews which we want don't want to include
        distinct order_id,
        review_id,
        review_score,
        review_comment_title as review_title,
        review_comment_message as review_message,
        cast(review_creation_date as date) as review_date,
        review_creation_date as review_timestamp,
        cast(review_answer_timestamp as date) as review_answer_date,
        review_answer_timestamp

    from {{ source('src_brazil_ecommerce', 'reviews')}}
)

select * from bec_reviews