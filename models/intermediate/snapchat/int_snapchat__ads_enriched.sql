    WITH ads AS (
        SELECT 
            *
        FROM {{ ref('stg_snapchat__ads') }}
    ),

    --The adgroup table contains multiple records for the same adgroup_id, we need to 
    --select the most recent record based on adgroup_updated_at
    adgroups AS (
        SELECT
            *,
            ROW_NUMBER() OVER(PARTITION BY adgroup_id ORDER BY adgroup_updated_at DESC) AS RN
        FROM marketing_dev.staging.stg_snapchat__adgroups
        QUALIFY RN = 1
    ),

    campaigns AS (
        SELECT 
            *
        FROM {{ ref('stg_snapchat__campaign') }}
    ),

    -- Join all the three tables to enrich the ads data with adgroup and campaign information

    enriched_ads AS (
        SELECT
            --PK
            a.ad_id AS ad_id,

            --FK
            c.account_id AS account_id,
            ag.campaign_id AS campaign_id,
            a.adgroup_id AS adgroup_id,
            
            -- Descriptive fields
            c.campaign_name AS campaign_name,
            ag.adgroup_name AS adgroup_name,
            a.ad_name AS ad_name,

            -- Timestamps
            ag.adgroup_updated_at AS adgroup_updated_at,
            a.ad_detail_updated_at AS ad_updated_at,
            
            -- Additional fields
            'snapchat_ads' AS data_source
        FROM ads AS a
        LEFT JOIN adgroups AS ag ON a.adgroup_id = ag.adgroup_id
        LEFT JOIN campaigns AS c ON ag.campaign_id = c.campaign_id
    )

    -- Final intermediate snapchat ads enriched table
        SELECT 
            * 
        FROM enriched_ads