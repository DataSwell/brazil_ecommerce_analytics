# dbt-Analytics

## Project - Brazil e-commerce analytics
In this project we will use the brazil e-commerce dataset from Kaggle (https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). The dataset includes information about e-commerce orders of brazil in the years 2016-2018.

## Extract


## Load


## Transform (dbt)
Using the ELT approach the transformation of the data starts after loading the data into the data warehouse (Redshift).

### Datamodel

### Sources

### Staging

### Marts
- **Dimensions (dim):**
	- customer
	- location
	- products
	- sellers
	- calendar

- **Facts (fct):** 
	- orders
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

- **customer & sellers:**
	- Where live the customers with the most value of orders?
	- Are products bought more in some regions than in others?
	- Where are the top-selling companies located
	- Which products do the top-selling companies sell?

- **orders/payment/reviews:**
	- How many orders were delivered in time?
	- Are specific prduct categories delayed with a higher percentage?
	- What type of payment is used most?
	- At what days are the most orders placed?
	- At what time during the day are orders made.
	- What percentage of orders get canceled?
	- What is the distribution of the the review rating?
	- What percentage of orders get reviewed?
	- What percentage of reviews gets answered?

	- What is the average deliverytime per seller/product category? --> In time delivery must be joined from orders to order_items
	





