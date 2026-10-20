WITH source_data AS (
    SELECT *
    FROM {{ source('snapchat_ads', 'ads') }}
),

--Trimming white spaces and casting to appropriate data types
formatted AS (
    SELECT
        --PK
        TRIM(CAST(ad_id AS STRING)) AS ad_id,

        --FK
        TRIM(CAST(ad_group_id AS STRING)) AS adgroup_id,
        
        --Dimensions
        TRIM(CAST(ad_name AS STRING)) AS ad_name,
        CAST(ad_detail_updated_at AS TIMESTAMP) AS ad_detail_updated_at
    FROM source_data
)

SELECT * FROM formatted