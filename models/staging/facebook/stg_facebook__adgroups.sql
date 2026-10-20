WITH source_data AS (
    SELECT *
    FROM {{ source('facebook_ads', 'adgroups') }}
),

--Trimming white spaces and casting to appropriate data types
formatted AS (
    SELECT
        --PK
        TRIM(CAST(ad_group_id AS STRING)) AS adgroup_id,
        
        --Dimensions
        TRIM(CAST(ad_group_name AS STRING)) AS adgroup_name,
        CAST(ad_group_updated_at AS TIMESTAMP) AS adgroup_updated_at
    FROM source_data
)

SELECT *
FROM formatted