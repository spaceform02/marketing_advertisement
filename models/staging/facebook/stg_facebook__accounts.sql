WITH source_data AS (
    SELECT *
    FROM {{ source('facebook_ads', 'accounts') }}
),


--Trimming white spaces and casting to appropriate data types
formatted AS (
    SELECT
        --PK
        TRIM(CAST(account_id AS STRING)) AS account_id,
        
        --Dimensions
        TRIM(CAST(account_name AS STRING)) AS account_name,
        TRIM(CAST(ad_currency_code AS STRING)) AS currency,
        CAST(account_created_at AS TIMESTAMP) AS account_created_at,
        CAST(account_updated_at AS TIMESTAMP) AS account_updated_at
    FROM source_data
)

SELECT *
FROM formatted