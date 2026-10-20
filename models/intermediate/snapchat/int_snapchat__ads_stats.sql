WITH ads_stat AS (
    SELECT 
        *
    FROM {{ ref('stg_snapchat__ads_stats') }}
),
--removing nulls and replacing with 0 for metrics
transformed AS (
    SELECT
        --PK
        ad_detail_id AS ad_id,

        --Metrics
        COALESCE(spend, 0.00) AS spend,
        COALESCE(impressions, 0) AS impressions,
        COALESCE(clicks, 0) AS clicks,

        --Dimensions
        currency,
        CASE
            WHEN lower(country) = 'de' THEN 'Germany'
            WHEN lower(country) = 'at' THEN 'Austria'
            WHEN lower(country) = 'ch' THEN 'Switzerland'
            WHEN lower(country) = 'us' THEN 'United States'
            ELSE country
        END AS country,
        ad_date,
        data_src AS data_source
    FROM ads_stat
)

--Final Intermediate model for Snapchat Ads Stats with cleaned metrics
SELECT 
    *
FROM transformed