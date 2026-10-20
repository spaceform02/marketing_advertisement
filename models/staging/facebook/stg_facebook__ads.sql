WITH source_data AS (
    SELECT *
    FROM {{ source('facebook_ads', 'ads') }}
),

--Trimming white spaces and casting to appropriate data types
formatted AS (
    SELECT
        --PK
        TRIM(CAST(ad_id AS STRING)) AS ad_id,

        --FK
        TRIM(CAST(campaign_id AS STRING)) AS campaign_id,
        TRIM(CAST(ad_group_id AS STRING)) AS adgroup_id,
        TRIM(CAST(account_id AS STRING)) AS account_id,
        
        --Dimensions
        TRIM(CAST(ad_name AS STRING)) AS ad_name,
        TRIM(CAST(ad_status AS STRING)) AS ad_status,
        CAST(ad_updated_at AS TIMESTAMP) AS ad_updated_at
    FROM source_data
)

SELECT *
FROM formatted