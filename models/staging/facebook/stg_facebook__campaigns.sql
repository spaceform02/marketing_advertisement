WITH source_data AS (
    SELECT *
    FROM {{ source('facebook_ads', 'campaigns') }}
),

--Trimming white spaces and casting to appropriate data types
formatted AS (
    SELECT
        --PK
        TRIM(CAST(campaign_id AS STRING)) AS campaign_id,
        
        --Dimensions
        TRIM(CAST(campaign_name AS STRING)) AS campaign_name,
        CAST(campaign_updated_at AS TIMESTAMP) AS campaign_updated_at
    FROM source_data
)

SELECT * FROM formatted