
/* getting the reviews which are not unique. For those multiple reviews we will calculate the 

select *
from brazil_ecommerce.reviews
where review_id IN (
    select review_id from (
    select *,
    row_number() over(partition by review_id) as rn
    from brazil_ecommerce.reviews) rev
    where rev.rn >1)
order by review_id;

*/

with source as (

    select * from {{ source('src_brazil_ecommerce', 'reviews')}}
),

bec_reviews as (

    select
        distinct review_id,
        order_id,
        review_score,
        review_comment_title as review_title,
        review_comment_message as review_message,
        review_creation_date as review_date,
        review_answer_timestamp

    from {{ source('src_brazil_ecommerce', 'reviews')}}
)

select * from bec_reviews