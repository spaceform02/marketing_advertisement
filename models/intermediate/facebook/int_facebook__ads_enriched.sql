WITH ads AS (
    SELECT 
        *
    FROM {{ ref('stg_facebook__ads') }}
),

adgroups AS (
    SELECT 
        *
    FROM {{ ref('stg_facebook__adgroups') }}
),

campaigns AS (
    SELECT 
        *
    FROM {{ ref('stg_facebook__campaigns') }}
),

accounts AS (
    SELECT 
        *
    FROM {{ ref('stg_facebook__accounts') }}
),


-- Join all the four tables to enrich the ads data with adgroup, campaign, and account information

enriched_ads AS (
    SELECT
        --PK
        a.ad_id AS ad_id,

        --FK
        a.account_id AS account_id,
        a.campaign_id AS campaign_id,
        a.adgroup_id AS adgroup_id,
        
        -- Descriptive fields
        acc.account_name AS account_name,
        c.campaign_name AS campaign_name,
        ag.adgroup_name AS ad_group_name,
        a.ad_name AS ad_name,
        acc.currency AS currency,
        a.ad_status AS ad_status,

        -- Timestamps
        acc.account_created_at AS account_created_at,
        acc.account_updated_at AS account_updated_at,
        c.campaign_updated_at AS campaign_updated_at,
        ag.adgroup_updated_at AS adgroup_updated_at,
        a.ad_updated_at AS ad_updated_at,
        
        -- Additional fields
        'facebook_ads' AS data_source
    FROM ads AS a
    LEFT JOIN adgroups AS ag ON a.adgroup_id = ag.adgroup_id
    LEFT JOIN campaigns AS c ON a.campaign_id = c.campaign_id
    LEFT JOIN accounts AS acc ON a.account_id = acc.account_id
)

-- Final intermediate facebook ads enriched table
SELECT 
    * 
FROM enriched_ads