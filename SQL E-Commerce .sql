-------------------------------------------------------------------------------------------
use olist_store_analysis;
#Q-1 ------Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

SELECT
 CASE 
    WHEN DAYOFWEEK(order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,
  COUNT(*) AS total_orders,
 round( SUM(p.payment_value),0)AS total_payment,
  round(AVG(p.payment_value),2)AS avg_payment
FROM
  orders o
JOIN
  payments p ON o.order_id = p.order_id
GROUP BY
  day_type;
  -----------------------------------------------------------------------------------------------
#Q-2 ----Number of Orders with review score 5 and payment type as credit card.

SELECT 
  COUNT(DISTINCT r.order_id) AS total_orders
FROM 
  reviews r
JOIN 
  payments p ON r.order_id = p.order_id
WHERE 
  r.review_score = 5
  AND p.payment_type = 'credit_card';
  
  --------------------------------------------------------------------------------------------------------
  # Q-3---Average number of days taken for order_delivered_customer_date for pet_shop

  SELECT 
  AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_delivery_days
FROM 
  orders o
JOIN 
  items i ON o.order_id = i.order_id
JOIN 
  products p ON i.product_id = p.product_id
WHERE 
  p.product_category_name = 'pet_shop'
  AND o.order_delivered_customer_date IS NOT NULL;
  -----------------------------------------------------------------------------------------------------------------------
  # Q-4--Average price and payment values from customers of sao paulo city

  SELECT 
  ROUND(AVG(oi.price), 2) AS avg_price,
  ROUND(AVG(p.payment_value), 2) AS avg_payment
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN items oi ON o.order_id = oi.order_id
JOIN payments p ON o.order_id = p.order_id
WHERE c.customer_city = 'sao paulo';

  
  ----------------------------------------------------------------------
  # Q-5--Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

  SELECT
  r.review_score,
  AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_shipping_days,
  COUNT(*) AS total_orders
FROM
  orders o
JOIN
  reviews r ON o.order_id = r.order_id
WHERE
  o.order_delivered_customer_date IS NOT NULL
GROUP BY
  r.review_score
ORDER BY
  r.review_score;
  
  ---------------------------------------------------------------
  #Q-6------ Total Sales
  SELECT 
  round(sum(payment_value),0) AS total_sales
FROM payments ;
---------------------------------------------------------------
# Q-7--- Total Number of Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;
------------------------------------------------------------------
	# Q-8---Average Order Value (AOV)	
SELECT 
  ROUND(SUM(payment_value) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM payments;
----------------------------------------------------------------------

	 #Q-9---Average Shipping Cost per Order
  SELECT 
  ROUND(AVG(freight_value), 2) AS avg_shipping_cost
FROM items;
  ---------------------------------------------------------
#Q-10--- Abandoned Carts
SELECT COUNT(*) AS abandoned_orders
FROM orders
WHERE order_status = 'created';
-----------------------------------------------------------------------
  #Q-11----Sales Growth Rate 
  SELECT 
  DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
  ROUND(SUM(payment_value), 2) AS monthly_sales
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY month
ORDER BY month 
limit 5;
-------------------------------------------
  #Q-12--- Orders by Payment Method
  SELECT 
  payment_type,
  COUNT(DISTINCT order_id) AS total_orders,
  ROUND(SUM(payment_value), 2) AS total_payment
FROM payments
GROUP BY payment_type
ORDER BY total_payment DESC;
------------------------------------------------------------------------------

# Q-13--Top 5 States by Revenue
SELECT 
  c.customer_state,
  ROUND(SUM(oi.price), 2) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN items oi ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 5;
--------------------------------------------------
#Q-14--Avg Review_SCORE BY customer_city
call AvgReviewBycustomer_city;
---------------------------------------------

 # Q-15-- Top 5 Selling Products 
 
 SELECT 
  p.product_category_name,
  p.product_id,
  COUNT(*) AS total_orders,
  SUM(i.price) AS total_quantity_sold
FROM items i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.product_category_name, p.product_id
ORDER BY total_quantity_sold DESC
LIMIT 5;
----------------------------------------------

#Q-16--Top 5 Product Categories by Revenue
select
  p.product_category_name,
  ROUND(SUM(i.price + i.freight_value), 2) AS total_sales
FROM items i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_sales DESC
LIMIT 10;
  ------------------------------------------------------------------------------------
# Q-17--Orders with 5-Star Review and Fast Delivery
SELECT COUNT(*) AS fast_and_5star_orders
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE r.review_score = 5
  AND o.order_delivered_customer_date <= o.order_estimated_delivery_date;
---------------------------------------------------------------
#-Q-18----Actual vs. Estimated Delivery Gap Analysis
  select
  order_id,
  order_status,
  CAST(order_delivered_customer_date AS DATETIME) AS delivered_date,
  CAST(order_estimated_delivery_date AS DATETIME) AS estimated_date,
  DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date)AS date_diff 
FROM orders   
WHERE order_status = 'delivered' ;
----------------------------------------------------------------------------------
#Q19--Top 10 Sellers by Total Sales
 SELECT 
  s.seller_id, 
  round(sum(i.price),2) AS TotalSales
  FROM items i
  JOIN sellers s ON i.seller_id = s.seller_id
  GROUP BY s.seller_id
  ORDER BY TotalSales DESC
  LIMIT 10;
-----------------------------------------------------------------------------


