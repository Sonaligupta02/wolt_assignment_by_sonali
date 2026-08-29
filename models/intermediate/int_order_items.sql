{{ config(
    materialized='table'
) }}

WITH purchases AS (

    SELECT
        purchase_key,
        customer_key,
        order_received_at,
        delivery_distance_meters,
        wolt_service_fee,
        courier_base_fee,
        total_basket_value,
        item_basket_description
    FROM {{ ref('stg_purchases') }}

),

order_items AS (

    SELECT
        purchase_key,
        customer_key,
        order_received_at,
        delivery_distance_meters,
        wolt_service_fee,
        courier_base_fee,
        total_basket_value,
        JSON_VALUE(item, '$.item_key') AS item_key,
         SAFE_CAST(JSON_VALUE(item, '$.item_count') AS INT64 ) AS quantity
FROM purchases, 
UNNEST(JSON_QUERY_ARRAY(item_basket_description) ) AS item

)

SELECT *
FROM order_items

