{{ config(
    materialized='table'
) }}

WITH order_items AS (

    SELECT *
    FROM {{ ref('int_order_items') }}

),

item_history AS (

    SELECT *
    FROM {{ ref('int_item_history') }}

),

matched_prices AS (

    SELECT
        oi.purchase_key,
        oi.customer_key,
        oi.order_received_at,
        oi.delivery_distance_meters, 
        oi.item_key,
        oi.quantity,
        oi.total_basket_value,
        oi.wolt_service_fee,
        oi.courier_base_fee,

        ih.item_name,
        ih.item_category,
        ih.brand_name,
        ih.product_base_price,
        ih.vat_rate_in_percent,

        ROW_NUMBER() OVER (
            PARTITION BY
                oi.purchase_key,
                oi.item_key
            ORDER BY ih.time_log_created_utc DESC
        ) AS rn

    FROM order_items oi

    LEFT JOIN item_history ih
        ON oi.item_key = ih.item_key
        AND ih.time_log_created_utc <= oi.order_received_at

)

SELECT
    purchase_key,
    customer_key,
    order_received_at,
    delivery_distance_meters,
    item_key,
    item_name,
    item_category,
    brand_name,
    quantity,
    product_base_price,
    vat_rate_in_percent,
    total_basket_value,
    wolt_service_fee,
    courier_base_fee

FROM matched_prices

WHERE rn = 1
