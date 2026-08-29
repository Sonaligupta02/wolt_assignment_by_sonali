WITH source_data AS (

    SELECT
        LOG_ITEM_ID AS log_item_id,
        ITEM_KEY AS item_key,
        TIME_LOG_CREATED_UTC AS time_log_created_utc,
        PAYLOAD AS payload
    FROM {{ source('wolt_snack_raw', 'snack_store_item_logs') }}

),

deduplicated AS (

    SELECT *
    FROM source_data
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY log_item_id
        ORDER BY
            CASE
                WHEN JSON_VALUE(
                    payload,
                    '$.price_attributes[0].product_base_price'
                ) IS NOT NULL
                THEN 1
                ELSE 2
            END
    ) = 1

)

SELECT *
FROM deduplicated
