{{ config(
    materialized='table'
) }}

WITH order_items AS (

    SELECT *
    FROM {{ ref('int_order_item_pricing') }}

),

promotions AS (

    SELECT
        item_key,
        promo_start_date,
        promo_end_date,
        promo_type,
        discount_percentage
    FROM {{ ref('stg_promos') }}

),

promotion_matches AS (

    SELECT
        oi.purchase_key,
        oi.customer_key,
        oi.order_received_at,
        oi.delivery_distance_meters,
        oi.item_key,
        oi.item_name,
        oi.item_category,
        oi.brand_name,
        oi.quantity,
        oi.product_base_price,
        oi.vat_rate_in_percent,
        oi.total_basket_value,
        oi.wolt_service_fee,
        oi.courier_base_fee,

        p.promo_type,
        p.discount_percentage,

        ROW_NUMBER() OVER (
            PARTITION BY
                oi.purchase_key,
                oi.item_key
            ORDER BY
                p.promo_start_date DESC
        ) AS rn

    FROM order_items oi

    LEFT JOIN promotions p
        ON oi.item_key = p.item_key
        AND DATE(oi.order_received_at)
            >= p.promo_start_date
        AND DATE(oi.order_received_at)
            < p.promo_end_date

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

    promo_type,

    COALESCE(discount_percentage, 0)
        AS discount_percentage,

    CASE
        WHEN promo_type IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS is_on_promotion,

    product_base_price
        * COALESCE(discount_percentage, 0) / 100
        AS discount_amount_per_unit,

    product_base_price
        * (
            1 - COALESCE(discount_percentage, 0) / 100
        )
        AS final_item_price_per_unit,

    quantity
        * product_base_price
        * (
            1 - COALESCE(discount_percentage, 0) / 100
        )
        AS final_item_value,

    total_basket_value,
    wolt_service_fee,
    courier_base_fee

FROM promotion_matches

WHERE rn = 1
