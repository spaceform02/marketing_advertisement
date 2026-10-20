WITH source_data AS (
    SELECT *
    FROM {{ source('facebook_ads', 'ads_stats') }}
),

--Trimming white spaces and casting to appropriate data types
formatted AS (
    SELECT
        --PK
        TRIM(CAST(ad_id AS STRING)) AS ad_id,

        --FK
        TRIM(CAST(account_id AS STRING)) AS account_id,

        --Metrics
        TRY_CAST(ad_spend AS DOUBLE) AS ad_spend,
        TRY_CAST(ad_impressions AS INTEGER) AS ad_impressions,
        TRY_CAST(ad_clicks AS INTEGER) AS ad_clicks,
        
        --Dimensions
        CAST(ad_date AS DATE) AS ad_date
    FROM source_data
)

SELECT *
FROM formatted