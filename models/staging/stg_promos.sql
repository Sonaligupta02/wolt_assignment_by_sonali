SELECT
    ITEM_KEY AS item_key,
    PROMO_START_DATE AS promo_start_date,
    PROMO_END_DATE AS promo_end_date,
    PROMO_TYPE AS promo_type,
    DISCOUNT_IN_PERCENTAGE AS discount_percentage
FROM {{ source('wolt_snack_raw', 'snack_store_promos') }}

