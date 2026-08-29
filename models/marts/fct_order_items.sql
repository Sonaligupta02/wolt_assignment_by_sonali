{{ config(
    materialized='table'
) }}

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

    discount_percentage,
    is_on_promotion,

    discount_amount_per_unit,
    final_item_price_per_unit,
    final_item_value,

    total_basket_value,
    wolt_service_fee,
    courier_base_fee

FROM {{ ref('int_order_item_promotions') }}
