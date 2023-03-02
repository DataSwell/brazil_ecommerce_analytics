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
More information under the topic Sources & Seeds.

## Transform (dbt)
Using the ELT approach the transformation of the data starts after loading the data into the data warehouse (Redshift).

### Project structure & Datamodel

**Attention:** For this project I use the free dbt-Cloud version, which allows us to only manage one project. 
Because I'm also using dbt-Cloud for the dbt-training project "jaffle_shop", we have two projects combined in this one dbt-project structure. 
The two projects are seperated from each other by using different subfolders in our models and unified prefixes (bec) for the SQL files (image below, left)

Dbt-Cloud also allows us only to connect to one database in AWS Redshift. Therefore we have a similiar structure in Redshift as well. The raw data for both projects (brazil_ecommerce, jaffle_shop) and the from dbt created models are stored in different schemas in the same database "analytics" (image below, right).

![dbt_and_redshift_structure](https://user-images.githubusercontent.com/63445819/222439077-4c4aef58-7acb-4fc2-9df6-2e415ea451b8.png)

The dbt structure with the different layers and functionalities will be explained in the next parts. In each layer (staging, intermediate, marts) exists YAML files and SQL files. The YAML files are used for configuration, we can specify descriptions for models and columns or add generic tests. The SQL files contain the code which will be compiled and run by dbt in our data warehouse, to transform the data and create views/tables/CTEs.

### Sources & Seeds

### Staging

### Marts
- **Dimensions (dim):**
	- customer
	- products
	- sellers
	- calendar

- **Facts (fct):** 
	- orders
    - order_items
	- payments

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
	





