{{ config(
    materialized='table'
) }}

WITH source_data AS (

    SELECT
        log_item_id,
        item_key,
        time_log_created_utc,
        payload
    FROM {{ ref('stg_item_logs') }}

),

parsed AS (

    SELECT
        log_item_id,
        item_key,
        time_log_created_utc,

        -- Product information
        JSON_VALUE(payload, '$.brand_name') AS brand_name,

        JSON_VALUE(payload, '$.item_category') AS item_category,

        -- Extract English product name
        (
            SELECT JSON_VALUE(name_item, '$.value')
            FROM UNNEST(JSON_QUERY_ARRAY(payload, '$.name')) AS name_item
            WHERE JSON_VALUE(name_item, '$.lang') = 'en'
            LIMIT 1
        ) AS item_name,

        -- Price information
        SAFE_CAST(
            JSON_VALUE(
                payload,
                '$.price_attributes[0].product_base_price'
            ) AS NUMERIC
        ) AS product_base_price,

        SAFE_CAST(
            JSON_VALUE(
                payload,
                '$.price_attributes[0].vat_rate_in_percent'
            ) AS NUMERIC
        ) AS vat_rate_in_percent,

        JSON_VALUE(
            payload,
            '$.price_attributes[0].currency'
        ) AS currency,

        -- Product attributes
        SAFE_CAST(
            JSON_VALUE(
                payload,
                '$.number_of_units'
            ) AS INT64
        ) AS number_of_units,

        SAFE_CAST(
            JSON_VALUE(
                payload,
                '$.weight_in_grams'
            ) AS NUMERIC
        ) AS weight_in_grams,

        SAFE_CAST(
            JSON_VALUE(
                payload,
                '$.time_item_created_in_source_utc'
            ) AS TIMESTAMP
        ) AS item_created_at

    FROM source_data

)

SELECT *
FROM parsed
