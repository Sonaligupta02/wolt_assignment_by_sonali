{{ config(
    materialized='table'
) }}

WITH monthly_product AS (

    SELECT
        FORMAT_DATE('%Y-%m', DATE(order_received_at)) AS month,

        item_category,

        item_name,

        COUNT(DISTINCT purchase_key) AS orders,

        COUNT(DISTINCT customer_key) AS customers,

        SUM(quantity) AS items_sold,

        ROUND(SUM(final_item_value), 2) AS revenue,

        ROUND(AVG(product_base_price), 2) AS average_price

    FROM {{ ref('fct_order_items') }}

    WHERE DATE(order_received_at)
          BETWEEN '2023-01-01' AND '2023-12-31'

    GROUP BY
        month,
        item_category,
        item_name
)

SELECT
    month,
    item_category,
    item_name,

    orders,
    customers,
    items_sold,
    revenue,
    average_price

FROM monthly_product

ORDER BY
    month,
    revenue DESC
