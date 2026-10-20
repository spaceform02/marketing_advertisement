WITH ads_stat AS (
    SELECT 
        *
    FROM {{ ref('stg_facebook__ads_stats') }}
),
--removing nulls and replacing with 0 for metrics
transformed AS (
    SELECT
        --PK
        ad_id,

        --FK
        account_id,

        --Metrics
        COALESCE(ad_spend, 0.00) AS spend,
        COALESCE(ad_impressions, 0) AS impressions,
        COALESCE(ad_clicks, 0) AS clicks,

        --Dimensions
        ad_date,
        'facebook_ads' AS data_source
    FROM ads_stat
)

--Final Intermediate model for Facebook Ads Stats with cleaned metrics
SELECT 
    *
FROM transformed

    

