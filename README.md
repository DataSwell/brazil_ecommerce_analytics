# dbt-Analytics

## Project - Brazil e-commerce analytics
In this project we will use the brazil e-commerce (bce) dataset of the company Olist from Kaggle (https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
Olist operates as an online e-commerce site for sellers, that connects merchants and their products to the main marketplaces of Brazil. 
The dataset provides information about e-commerce orders in the years 2016-2018. 

**Context**

This dataset was generously provided by Olist, the largest department store in Brazilian marketplaces. Olist connects small businesses from all over Brazil to channels without hassle and with a single contract. Those merchants are able to sell their products through the Olist Store and ship them directly to the customers using Olist logistics partners. 
See more on our website: www.olist.com. After a customer purchases the product from Olist Store a seller gets notified to fulfill that order. Once the customer receives the product, or the estimated delivery date is due, the customer gets a satisfaction survey by email where he can give a note for the purchase experience and write down some comments.

**Attention**
- An order might have multiple items.
- Each item might be fulfilled by a distinct seller.
- All text identifying stores and partners where replaced by the names of Game of Thrones great houses.

The project follows the for the modern data stack more common ELT approch instead of ETL. All the data from kaggle will be loaded into a Redshift data warehouse. 
Afterwards the data will be transformed and new models will be build with dbt. In dbt it is also possible to include tests and documentation for the project.



## Extract
For this project the data got extracted/downloaded from the kaggle website. The data was already split in 9 different csv files.

## Load
The CSV files from the Kaggle project were loaded into a S3 bucket. 

Afterwards we create the tables in Redshift for our raw data and copy the data from the files of the S3 bucket into Redshift.
```
copy brazil_ecommerce.customers from 's3://brazil-ecommerce/olist_customers.csv' 
iam_role 'arn:aws:iam::placeholder:role/placeholder'
CSV
IGNOREHEADER 1;
```

The calendar data which is needed for time anaylses is loaded directly as a CSV file into the dbt seed folder. 
More information under the topic Sources & Seeds.

## Transform (dbt)
Using the ELT approach the transformation of the data starts after loading the data into the data warehouse (Redshift).

### Project structure & Datamodel

**Attention:** For this project I use the free dbt-Cloud version, which allows us to only manage one project. 
Because I'm also using dbt-Cloud for the dbt-training project "jaffle_shop", we have two projects combined in this one dbt-project structure. 
The two projects are seperated from each other by using different subfolders in our models and unified prefixes (bec) for the SQL files.

- Projectstructure 
- Materialization and structure in Redshift

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

- **customer / sellers / reviews:**
	- Where live the customers with the most value of orders?
	- Are products bought more in some regions than in others?
	- Where are the top-selling companies located
	- Which products do the top-selling companies sell?

- **orders / payment:**
	- How many orders were delivered in time?
	- Are specific prduct categories delayed with a higher percentage?
	- What type of payment is used most?
	- At what days are the most orders placed?
	- What percentage of orders get canceled?
	- What is the distribution of the the review rating?
	- What percentage of orders get reviewed?
	- What percentage of reviews gets answered?

	





