SELECT
    PURCHASE_KEY AS purchase_key,
    CUSTOMER_KEY AS customer_key,
    TIME_ORDER_RECEIVED_UTC AS order_received_at,
    DELIVERY_DISTANCE_LINE_METERS AS delivery_distance_meters,
    WOLT_SERVICE_FEE AS wolt_service_fee,
    COURIER_BASE_FEE AS courier_base_fee,
    TOTAL_BASKET_VALUE AS total_basket_value,
    ITEM_BASKET_DESCRIPTION AS item_basket_description

FROM {{ source('wolt_snack_raw', 'snack_store_purchase_logs') }}