WITH fact_table AS (
    SELECT
        *
    FROM {{ ref('marts__ads_performance') }}
),

-- Aggregating the metrics at the platform level to get  overview of performance 
--across different advertising platforms.

platform_agg AS (
    SELECT
    -- Platform & Currency Dimensions
    data_source,
    currency,

    -- Aggregated Metrics
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,

    -- Calculated Performance Metrics 
    ROUND(SUM(clicks) / NULLIF(SUM(impressions), 0), 5) AS ctr,
    ROUND(SUM(spend) / NULLIF(SUM(clicks), 0), 2) AS cpc,
    ROUND((SUM(spend) / NULLIF(SUM(impressions), 0)) * 1000, 2) AS cpm

FROM fact_table
GROUP BY data_source, currency
)

SELECT 
    * 
FROM platform_agg


