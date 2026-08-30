-- Q1: 1) What area is the store serving in any given period?: Store serving area by month

SELECT
    FORMAT_DATE('%Y-%m', DATE(order_received_at)) AS month,
    CASE
        WHEN delivery_distance_meters < 3000 THEN '1–3 km'
        WHEN delivery_distance_meters < 5000 THEN '3–5 km'
        ELSE '5+ km'
    END AS delivery_distance_band,
    COUNT(DISTINCT purchase_key) AS orders
FROM `wolt-project-506607.wolt_snack_dbt.fct_order_items`
GROUP BY month, delivery_distance_band
ORDER BY month, delivery_distance_band;


-- 2. What items are being bought and what price are they going for in any given period?:  Items and prices by month

SELECT
    FORMAT_DATE('%Y-%m', DATE(order_received_at)) AS month,
    item_name,
    SUM(quantity) AS items_sold,
    SUM(final_item_price_per_unit) AS item_price
FROM `wolt-project-506607.wolt_snack_dbt.fct_order_items`
GROUP BY month, item_name
ORDER BY month, items_sold DESC;


--3. How many items are being bought on promotion in any given period?:  Promotional items by month

SELECT
    FORMAT_DATE('%Y-%m', DATE(order_received_at)) AS month,
    SUM(quantity) AS promoted_items
FROM `wolt-project-506607.wolt_snack_dbt.fct_order_items`
WHERE is_on_promotion = TRUE
GROUP BY month
ORDER BY month;



-- 4. Are customers taking advantage of promotions?: Promotion usage by customers

SELECT
  --  FORMAT_DATE('%Y-%m', DATE(order_received_at)) AS month,
    is_on_promotion,
    COUNT(DISTINCT customer_key) AS customers,
    COUNT(DISTINCT purchase_key) AS orders,
    SUM(quantity) AS items_sold
FROM `wolt-project-506607.wolt_snack_dbt.fct_order_items`
GROUP BY  is_on_promotion
ORDER BY  is_on_promotion;



-- 5. Are customers coming back to the store?: Returning customers

SELECT
    customer_key,
    COUNT(DISTINCT purchase_key) AS number_of_orders
FROM `wolt-project-506607.wolt_snack_dbt.fct_order_items`
GROUP BY customer_key
HAVING COUNT(DISTINCT purchase_key) > 1
ORDER BY number_of_orders DESC;



-- 6. How do Wolt and Courier fees compare to basket value?: Fees compared with basket value

SELECT
   -- FORMAT_DATE('%Y-%m', DATE(order_received_at)) AS month,
    ROUND(SUM(total_basket_value), 2) AS average_basket_value,
    ROUND(SUM(wolt_service_fee), 2) AS average_wolt_fee,
    ROUND(SUM(courier_base_fee), 2) AS average_courier_fee
FROM `wolt-project-506607.wolt_snack_dbt.fct_order_items`;

-- Q7: How much revenue has the company generated in any given period? : Revenue by month

SELECT
    FORMAT_DATE('%Y-%m', DATE(order_received_at)) AS month,
    ROUND(SUM(final_item_value), 2) AS revenue
FROM `wolt-project-506607.wolt_snack_dbt.fct_order_items`
GROUP BY month
ORDER BY month;


-- 8. How much are courier costs in any given period?:  Courier costs by month

SELECT
    FORMAT_DATE('%Y-%m', DATE(order_received_at)) AS month,
    ROUND(SUM(courier_base_fee), 2) AS courier_cost
FROM `wolt-project-506607.wolt_snack_dbt.fct_order_items`
GROUP BY month
ORDER BY month;
