WITH facebook_ads_stat AS (
    SELECT *
    FROM {{ ref('int_facebook__ads_stat') }}
),

facebook_ads_enriched AS (
    SELECT *
    FROM {{ ref('int_facebook__ads_enriched') }}
),


snapchat_ads_stat AS (
    SELECT *
    FROM {{ ref('int_snapchat__ads_stats') }}
),

snapchat_ads_enriched AS (
    SELECT *
    FROM {{ ref('int_snapchat__ads_enriched') }}
),

--Joining the intermediate models for facebook to extract currency and campaign name for each ad performance record. 
--This is done to ensure that the facts table has all the necessary descriptive fields for analysis.

facebook_joins AS (
    SELECT 
        --PK
        fas.ad_id AS ad_id,

         --needed to calaculate metrics at the campaign level
        fae.campaign_name AS campaign_name,
        
        -- Metrics
        fas.spend AS spend,
        fas.impressions AS impressions,
        fas.clicks AS clicks,

        -- Dimensions
        fae.currency AS currency,
        fas.ad_date AS ad_date, 
        fas.data_source AS data_source
    FROM facebook_ads_stat AS fas
    LEFT JOIN facebook_ads_enriched AS fae
        ON fas.ad_id = fae.ad_id
),

--Joining the intermediate models for snapchat to extract campaign name for each ad performance record. 
--This is done to ensure that the facts table has all the necessary descriptive fields for analysis.

snapchat_joins AS (
    SELECT 
        --PK
        sas.ad_id AS ad_id,

         --needed to calaculate metrics at the campaign and currency level
        sae.campaign_name AS campaign_name,

        -- Metrics
        sas.spend AS spend,
        sas.impressions AS impressions,
        sas.clicks AS clicks,

        -- Dimensions
        sas.currency AS currency,
        sas.ad_date AS ad_date, 
        sas.data_source AS data_source
    FROM snapchat_ads_stat AS sas
    LEFT JOIN snapchat_ads_enriched AS sae
        ON sas.ad_id = sae.ad_id
), 

combined AS (
    SELECT * FROM facebook_joins
    UNION ALL
    SELECT * FROM snapchat_joins
)

-- Final facts table for ad performance metrics across Facebook and Snapchat
SELECT 
    *
FROM combined
