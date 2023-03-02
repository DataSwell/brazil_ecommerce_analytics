# Brazil e-commerce data analytics with dbt

In this project we will use the brazil e-commerce (bce) dataset from Kaggle (https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

>**Context**
>
>This dataset was generously provided by Olist, the largest department store in Brazilian marketplaces. Olist connects small businesses from all over Brazil to channels without hassle and with a single contract. Those merchants are able to sell their products through the Olist Store and ship them directly to the customers using Olist logistics partners(www.olist.com). After a customer purchases the product from Olist Store a seller gets notified to fulfill that order. Once the customer receives the product, or the estimated delivery date is due, the customer gets a satisfaction survey by email where he can give a note for the purchase experience and write down some comments. The dataset provides information about e-commerce orders in the years 2016-2018. 
>
>**Attention**
>- An order might have multiple items.
>- Each item might be fulfilled by a distinct seller.
>- All text identifying stores and partners where replaced by the names of Game of Thrones great houses.

The project follows the for the modern data stack more common ELT approch instead of ETL. All the data from kaggle will be loaded into **Redshift** a data warehouse. 
Afterwards the data will be transformed and new models will be build with **dbt**. In dbt it is also possible to include tests and documentation. After transforming the data and building data marts, the data marts can be analysed with BI tools like **Power BI**, which I will use to create dashboards.


## Extract
For this project the data got extracted/downloaded from the kaggle website. The data was already split in 9 different csv files.

## Load
The CSV files from the Kaggle project were loaded into a S3 bucket.
![bce_s3_bucket](https://user-images.githubusercontent.com/63445819/222436537-3ce9752a-f2be-4fb4-82a7-a18f1ab765bb.png)

Afterwards I created in Redshift one table for each csv file and copied the raw data from the S3 bucket into Redshift. The image below shows the COPY command for the customers data from the customer.csv file into the Redshift table brazil_ecommerce.customers
```
copy brazil_ecommerce.customers from 's3://brazil-ecommerce/olist_customers.csv' 
iam_role 'arn:aws:iam::placeholder:role/placeholder'
CSV
IGNOREHEADER 1;
```

The time data (calendar) which is needed for time anaylses is loaded directly as a CSV file into the dbt seed folder. 
More information under the topic Transform-Seeds.

## Transform (dbt)
Using the ELT approach the transformation of the data starts after loading the data into the data warehouse (Redshift).

### Project structure & Datamodel

**Attention:** For this project I use the free dbt-Cloud version, which allows us to only manage one project. 
Because I'm also using dbt-Cloud for the dbt-training project "jaffle_shop", we have two projects combined in this one dbt-project structure. 
The two projects are seperated from each other by using different subfolders in our models and unified prefixes (bec) for the SQL files (image below, left)

Dbt-Cloud also allows us only to connect to one database in AWS Redshift. Therefore we have a similiar structure in Redshift as well. The raw data for both projects (brazil_ecommerce, jaffle_shop) and the from dbt created models are stored in different schemas in the same database "analytics" (image below, right).

![dbt_and_redshift_structure](https://user-images.githubusercontent.com/63445819/222439077-4c4aef58-7acb-4fc2-9df6-2e415ea451b8.png)

The dbt structure with the different layers and functionalities will be explained in the next parts. In each layer (staging, intermediate, marts) exists YAML files and SQL files. The YAML files are used for configuration, we can specify descriptions for models and columns or add generic tests. The SQL files contain the code which will be compiled and run by dbt in our data warehouse, to transform the data and create views/tables/CTEs.

The folder structure of the project should reflect the data flow. It starts with a wide variety of source-conformed models and transforms them into fewer, richer business-conformed models. This can be dimensional models with a star/snowflake schema or wide tables for different business topics.

### Staging

The goal of the staging layer is to access the raw data of Redshift, select the necessary columns and process light transformations like changing column names, generating new columns by concatenating information. A best practise is to use consistent pattern of file names. After the "bec" prefix all staging models continue with a "stg" prefix. Another best practice by dbt is to use for each raw data table one seperate staging model SQL-file.

The staging folder contains the two YAML files sources and staging. The sources YAML-file configures which data from Redshift will be accessed. The image below shows the bec_sources.yml file. The name of the source is "src_brazil_ecommerce" and will be needed in the SQL-files. As well I add a short description, the referenced database and the schema in the database. For each table in Redshift I also added tests for specific columns.

![sources_yaml](https://user-images.githubusercontent.com/63445819/222470756-1aef0b42-6500-47be-90b8-81a9e5044e06.png)

The staging.yml file is similiar and contains the configuration for each staging-model file, with the name and also generic tests.

Each staging models is organized with two CTEs. One for pulling the data from the specified sources (sources.yml) with the source() macro and one to process the transformation. In the exampe below we use the CTE source to pull the data from the source table payment of the previously defined source "src_brazil_ecommerce". Afterwards we transform the data in the CTE bec_payments to generate a surrogate key by concatenating two columns. The transformed data will be materialized as a view in Redshift. The materialization of the models can be specified for each model layer in the dbt_project.yml file.

```
with source as (

    select * from {{ source('src_brazil_ecommerce', 'payments')}}
),

bec_payments as (

    select 
        -- concat for creating surrogate key
        concat(order_id, cast(payment_sequential as varchar(2))) as payment_id,
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value as amount

    from source
)

select * from bec_payments
```

### Intermediate 

In the intermediate layer are SQL-files with more complex transformations then in the staging layer. The layer will be often used for transformations like pivoting, aggregation or joining. We have two intermediate modules in this project, which use the prefix "int" in their filenames. For example, the file bec_int_payments.sql pivot the different payments for one order and aggregates the grain of the different payments for each payment_type as well as the total amount per order.

```
{% set payment_methods = ['credit_card', 'voucher', 'not_defined', 'boleto', 'debit_card'] %}
 

with payments as (

   select * from {{ ref('bec_stg_payments') }}
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
```

The image below shows the difference between the tables created by the payments staging model (top) and the pivoted intermediate model (bottom)

![int_payment](https://user-images.githubusercontent.com/63445819/222537089-ed279900-66e3-4dd8-aa39-a95ecf748b2d.png)


### Marts

#### Dimensions
	- customer
	- products
	- sellers
	- calendar

#### Facts
	- orders
	- order_items
	- payments

### dbt DAGs / Lineage

### Seeds

### Tests
- **Generic Tests**
are written in YAML and return the number of records that do not meet your assertions. These are run on specific columns in a model. The standard package provides the generic tests: unique, not_null, accepted_values and relationships. The tests unique and not_null for example can be used to test primary keys.


- **Singular Tests**
are specific queries that you run against your models. These are run on the entire model. These types of tests are user defined tests for specific attributes that needs to be validatet. For example the total amount of an order can not be negative. These type of tests are not specified in the YML file, they are saved as a SQL file in the tests order of the dbt-project.


### Documentation

## Analytics & Visualization 

### Metrics/KPI

- **products:**
	- Which product categories are bought the most?
	- What are Count, SUM, AVG, MIN, MAX per product group?
	- In which months are most products bought? 
	- Is there a difference during the years?
	- Are products with more pictures ordered more often than others from the same category?

![oilst_product_data_dasboard](https://user-images.githubusercontent.com/63445819/222457102-2825a6ae-2a1c-4f38-9626-337bf6fc62d8.png)

- **customer / sellers / reviews:**
	- Where live the customers with the most value of orders?
	- Are products bought more in some regions than in others?
	- Where are the top-selling companies located
	- Which products do the top-selling companies sell?

![oilst_customer_seller_data_dasboard](https://user-images.githubusercontent.com/63445819/222457149-ed6b2fef-2239-444c-995d-3e2e99d92a54.png)


- **orders / payment:**
	- How many orders were delivered in time?
	- Are specific prduct categories delayed with a higher percentage?
	- What type of payment is used most?
	- At what days are the most orders placed?
	- What percentage of orders get canceled?
	- What is the distribution of the the review rating?
	- What percentage of orders get reviewed?
	- What percentage of reviews gets answered?

![oilst_order_and_payment_data_dasboard](https://user-images.githubusercontent.com/63445819/222457184-3f86e1c2-7644-44d2-87b7-a5cd96e7e918.png)
	





