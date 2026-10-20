WITH source_data AS (
    SELECT *
    FROM {{ source('snapchat_ads', 'campaign') }}
),

--Trimming white spaces and casting to appropriate data types
formatted AS (  
    SELECT
        --PK
        TRIM(CAST(campaign_id AS STRING)) AS campaign_id,
        TRIM(CAST(account_id AS STRING)) AS account_id,

        --Dimensions
        TRIM(CAST(campaign_name AS STRING)) AS campaign_name
    FROM source_data
)

SELECT * FROM formatted
