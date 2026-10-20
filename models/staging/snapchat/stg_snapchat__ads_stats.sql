WITH source_data AS (
    SELECT *
    FROM {{ source('snapchat_ads', 'ads_stat') }}
),

--Trimming white spaces and casting to appropriate data types
formatted AS (
    SELECT
        --PK
        TRIM(CAST(ad_detail_id AS STRING)) AS ad_detail_id,
        
        --metrics
        TRY_CAST(ad_spend AS DOUBLE) AS spend,
        TRY_CAST(ad_impressions AS INTEGER) AS impressions,
        TRY_CAST(ad_clicks AS INTEGER) AS clicks,

        --Dimensions
        TRIM(CAST(ad_currency_code AS STRING)) AS currency,
        TRIM(CAST(ad_country AS STRING)) AS country,
        CAST(ad_date AS DATE) AS ad_date,
        TRIM(CAST(data_src AS STRING)) AS data_src
    FROM source_data
)

SELECT * FROM formatted