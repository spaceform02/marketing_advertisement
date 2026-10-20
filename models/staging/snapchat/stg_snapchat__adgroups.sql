WITH source_data AS (
    SELECT *
    FROM {{ source('snapchat_ads', 'adgroup') }}
),

--Trimming white spaces and casting to appropriate data types
formatted AS (
    SELECT
        --PK
        TRIM(CAST(_surrogate_key AS STRING)) AS surrogate_key,
        TRIM(CAST(ad_group_id AS STRING)) AS adgroup_id,
        
        --FK
        TRIM(CAST(campaign_id AS STRING)) AS campaign_id,
        
        --Dimensions
        TRIM(CAST(ad_group_name AS STRING)) AS adgroup_name,
        CAST(ad_group_updated_at AS TIMESTAMP) AS adgroup_updated_at
    FROM source_data
)

SELECT * FROM formatted
