CREATE DATABASE ecommerce_analytics;

use ecommerce_analytics;

select * 
from olist_customers_dataset
limit 5;

describe olist_customers_dataset;

select * 
from olist_order_items_dataset
limit 5;

describe olist_order_items_dataset;


select * 
from olist_order_payments_dataset
limit 5;

select * 
from olist_order_reviews_dataset
limit 5;

select * 
from olist_orders_dataset
limit 30;

SELECT DISTINCT order_status
FROM olist_orders_dataset;

select * 
from olist_products_dataset
limit 10;

select * 
from olist_sellers_dataset
limit 5;

select * 
from powerbi_sourcedata
limit 5;

select * 
from product_category_name_translation
limit 5;

#How many customers do we have?
select count(distinct customer_unique_id) as total_customer
from olist_customers_dataset;

#How many orders have been placed?
Select count(distinct order_id) as total_order
from olist_orders_dataset;

#How many products do we sell?
select count(distinct product_id ) as total_product
from olist_products_dataset;

#How many sellers are registered on our platform?
select count(distinct seller_id) as Total_seller
from olist_sellers_dataset;

#How many unique cities do our customers come from?
select count(distinct customer_city ) as total_unique_cities
from olist_customers_dataset;

#How many unique customer states do we have?
select count(distinct customer_state ) as total_unique_states
from olist_customers_dataset;

#How many orders were delivered?
select count(order_status) as total_oreders_delivered
from olist_orders_dataset
where order_status = "delivered";

#How many orders were cancelled?
select count(order_status) as total_oreders_cancelled
from olist_orders_dataset
where order_status = "Canceled";

#Show all shipped orders.
select order_id,customer_id,order_status 
from olist_orders_dataset
where order_status = "shipped";

#Show the first 10 orders that are currently in the processing status.
select order_id,customer_id,order_status 
from olist_orders_dataset
where order_status = "processing"
limit 10;

#Show me the 10 most recent orders.
select order_id,customer_id,order_purchase_timestamp
from olist_orders_dataset
order by order_purchase_timestamp desc
limit 10;

#Show the 10 oldest orders.
select order_id,customer_id,order_purchase_timestamp
from olist_orders_dataset
order by order_purchase_timestamp asc
limit 10;

#Display all customers sorted alphabetically by city.
select customer_unique_id,customer_city,customer_state 
from olist_customers_dataset
order by customer_city asc;

#Heavy products cost more to ship. Show us the heaviest products.
select product_id,product_weight_g 
from olist_products_dataset 
order by product_weight_g desc
limit 10;

#Show me the 10 most expensive order items.
select order_id,product_id,price
from olist_order_items_dataset
order by price desc
limit 10;

#How many customers do we have in each state?
select customer_state,count(distinct customer_id) as total_customer
from olist_customers_dataset
group by customer_state;

#How many orders are in each order status?
#Can you show the statuses with the highest number of orders first?
select order_status, count(*) as total_orders
from olist_orders_dataset
group by order_status
order by total_orders desc;

#How many sellers are there in each state?
#Can you show only the top 5 states with the highest number of sellers?
select seller_state,count(*) as total_sellers
from olist_sellers_dataset
group by seller_state
order by total_sellers desc 
limit 5;

#What is the average payment value for each payment type?
select payment_type ,round(avg(payment_value),2)as avrage_payment_value
from olist_order_payments_dataset
group by payment_type;

#What is the average product weight for each product category?
select product_category_name,round(avg(product_weight_g),2) as average_product_weight
from olist_products_dataset
group by product_category_name
order by average_product_weight desc;

#How many orders were placed by customers from each state?
select customer_state , count(o.order_id) as total_order
from olist_customers_dataset c
inner join olist_orders_dataset o 
on c.customer_id = o.customer_id
group by customer_state
order by total_order desc;

#Which customers have placed the most orders?
select customer_unique_id,count(o.order_id) as total_order
from olist_customers_dataset c
inner join olist_orders_dataset o 
on c.customer_id = o.customer_id
group by customer_unique_id 
order by total_order desc
limit 10;

#Which payment methods are used most frequently?
select payment_type,count(order_id) as total_payment
from olist_order_payments_dataset
group by payment_type
order by total_payment desc;

#Which product categories have the highest number of sold items?
select product_category_name, count(o.order_item_id) as sold_items
from olist_products_dataset p 
inner join olist_order_items_dataset o 
on p.product_id = o.product_id
group by product_category_name
order by sold_items desc;

#Which product categories generated the highest revenue?
select p.product_category_name ,round(sum(o.price),2) as total_revenue
from olist_products_dataset p 
inner join olist_order_items_dataset o 
on p.product_id = o.product_id
group by product_category_name
order by total_revenue desc
LIMIT 10;

#Which customer states generated the highest revenue?(join 3 tables)
select customer_state ,  round(sum(payment_value),2) as total_payment_value
from olist_customers_dataset c 
inner join olist_orders_dataset o 
on c.customer_id = o.customer_id
inner join olist_order_payments_dataset p 
on o.order_id = p.order_id
group by customer_state
order by total_payment_value desc;

#Which sellers generated the highest revenue?
select s.seller_id ,s.seller_state, round(sum(oi.price),2) as highest_revenue
from olist_sellers_dataset s 
inner join olist_order_items_dataset oi
on s.seller_id = oi.seller_id
group by seller_id,seller_state
order by highest_revenue desc
limit 10;

#What is the average order value for customers in each state?
select c.customer_state,round(avg(p.payment_value),2) as order_value
from olist_customers_dataset c 
inner join olist_orders_dataset o
on c.customer_id = o.customer_id
inner join olist_order_payments_dataset p 
on o.order_id = p.order_id
group by customer_state
order by order_value desc;

#I want to know which 10 cities have generated the highest total revenue. This will help us decide where to increase our marketing budget.
select c.customer_city ,round(sum(oi.price),2) as total_revenue
from olist_customers_dataset c 
inner join olist_orders_dataset o 
on c.customer_id = o.customer_id
inner join olist_order_items_dataset oi
on o.order_id = oi.order_id
group by customer_city
order by total_revenue desc
limit 10;

#Which product categories generated the highest revenue in each customer state?
select  customer_state ,product_category_name ,round(sum(price),2) as higest_revenue
from olist_customers_dataset c 
inner join olist_orders_dataset o 
on c.customer_id = o.customer_id 
inner join olist_order_items_dataset oi
on o.order_id = oi.order_id
inner join olist_products_dataset p 
on oi.product_id = p.product_id
group by customer_state ,product_category_name
order by higest_revenue desc
limit 15;


#Show me only the customer states that have more than 5,000 customers
Select customer_state,count(customer_unique_id) as total_customer
from olist_customers_dataset
group by customer_state
having total_customer > 5000
order by total_customer desc;

#Show the product categories that have sold more than 1,000 items
select product_category_name , count(order_item_id) as sold_items
from olist_products_dataset p 
inner join olist_order_items_dataset oi
on p.product_id = oi.product_id
group by product_category_name
having sold_items >1000
order by sold_items desc;

#how me the sellers who have generated more than ₹100,000 in total revenue.
select s.seller_id ,round(sum(oi.price),2) as total_revenue
from olist_sellers_dataset s 
inner join olist_order_items_dataset oi
on s.seller_id = oi.seller_id 
group by s.seller_id 
having total_revenue > 100000
order by total_revenue desc;

#Which customer states have generated more than ₹500,000 in total revenue?
select customer_state , round(sum(price),2) as total_revenue
from olist_customers_dataset c
inner join olist_orders_dataset o 
on c.customer_id = o.customer_id 
inner join olist_order_items_dataset oi 
on oi.order_id = o.order_id 
group by customer_state 
having total_revenue > 500000 
order by total_revenue desc;

#The Sales Manager wants to categorize every sold item based on its price.
select order_id,product_id,price,
  case
     when price >= 500 then "high_value"
     when price between 100 and 499 then "medium_value"
     else "low_value"
   end as order_category
from olist_order_items_dataset
limit 10;

#How many sold items fall into each price category?
select 
  case
   when price >= 500 then "high_value"
   when price between 100 and 499 then "medium_Value" 
   else "low_value"
   end as order_category,
   count(order_item_id) as total_sold_items
from olist_order_items_dataset
group by order_category
order by total_sold_items desc;

#Show me the total revenue generated by each price category, but only include categories that generated more than ₹1,000,000 in revenue
select 
  case
   when price >= 500 then "high_value"
   when price between 100 and 499 then "medium_Value" 
   else "low_value"
   end as order_category,
   round(sum(price),2) as Total_revenue
from olist_order_items_dataset
group by order_category
having Total_revenue > 1000000
order by Total_revenue desc;

#Find all customers who have never placed an order.
select c.customer_id,c.customer_unique_id,c.customer_state 
from olist_customers_dataset c
left join olist_orders_dataset o
on c.customer_id = o.customer_id
where o.order_id is null;

#Find all customers who have placed orders, but those orders have never been delivered.
Select c.customer_id , o.order_id,o.order_status 
from olist_customers_dataset c 
inner join olist_orders_dataset o 
on c.customer_id = o.customer_id 
where order_status <> "delivered";

#Find all products whose price is higher than the average product price.
select product_id,price
from olist_order_items_dataset
where price > (select avg(price)
from olist_order_items_dataset)
order by price desc;
 
 #Find all sellers whose total revenue is greater than the average seller revenue
 select seller_id,price
 from olist_order_items_dataset
group by seller_id 
having sum(price)  >
    (select avg(price) 
    from olist_order_items_dataset);

#Find all orders whose payment value is greater than the average payment value.
select order_id,payment_value
from olist_order_payments_dataset
where payment_value >
(select avg(payment_value)
from olist_order_payments_dataset)
order by payment_value desc;

#Find all customers whose total payment is greater than the average payment of all customers
select c.customer_id ,op.payment_value
from olist_customers_dataset c
inner join olist_orders_dataset o
on c.customer_id = o.customer_id
inner join olist_order_payments_dataset op
on o.order_id = op.order_id
group by c.customer_id
 having sum(payment_value) > (select avg(payment_value)
         from olist_order_payments_dataset)
 order by payment_value;
 
 #Find all products whose weight is greater than the average product weight
 select product_id,product_category_name,product_weight_g
 from olist_products_dataset
 where product_weight_g > (select avg(product_weight_g)
						from olist_products_dataset)
order by product_weight_g desc;
 
 #The Marketing team wants customer states displayed in uppercase for a report.
 select customer_id,customer_state , upper(customer_state) as uppercase
 from olist_customers_dataset;
 
 #The Reporting Team wants all product category names displayed in lowercase to maintain a consistent format.
 select product_id,product_category_name,lower(product_category_name) as lower_category
 from olist_products_dataset;
 
 #The Product Team wants to identify products with very long category names.
select product_id,product_category_name,length(product_category_name) as category_lenth
 from olist_products_dataset
 order by category_lenth desc;
 
 #The Operations team wants a single column that combines the customer city and customer state.
 select customer_id,customer_city,customer_state,concat(customer_city,' ' ,customer_state) as customer_location
 from olist_customers_dataset;
 
 #The Logistics team only wants to see the first 3 characters of each customers city for a compact report.
 select customer_id,customer_city,substring(customer_city,1,3) as city_prefix
 from olist_customers_dataset;
 
 #the reporting team wants customer state codes to be more descriptive.
 select customer_id,customer_state, replace(customer_state,'SP','saopolo') as state_name
 from olist_customers_dataset