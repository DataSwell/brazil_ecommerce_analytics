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
- Dimensions (dim):
	- customer
	- location
	- products
	- sellers
	- calendar

- Facts (fct): 
	- orders
	- payments

### Tests
- **Generic Tests**:
In dbt are generic tests added in the YAML file of the model. The standard package provides the generic tests: unique, not_null, accepted_values and relationships. The tests unique and not_null for example can be used to test primary keys.


- Singular Tests:
These types of tests are user defined tests for specific attributes that needs to be validatet. For example the total amount of an order can not be negative. These type of tests are not specified in the YML file, they are saved as a SQL file in the tests order of the dbt-project.


### Documentation

## Analytics & Visualization 

### Metrics/KPI
- customer:
	- Where live the customers with the most amount and value of orders?
- products:
	- Which products / categories are bought the most?
	- Which product category has the largest share of sales?
	- Are products bought more in some regions than in others?
	- Is there any correlation between product groups?
	- Are products with more reviews ordered more often than others from the same category?
	- Are products with longer description ordered more often than others from the same category?
	- Are products with more pictures ordered more often than others from the same category?
	- What product category has the most & best reviews?
- sellers:
	- Where are the top-selling companies located
	- Which products do the top-selling companies sell?
- delivery:
	- What is the average deliverytime per seller/product category?
	- How many percentage of deliverys are in time?
- payment:
	- What type of payment is used most?
- calendar:
	- In which weeks are most products bought? 
	- Are there patterns for date and produkt category?
	- Are there patterns for during the week / weekend?
	- At what time during the day are orders made.





