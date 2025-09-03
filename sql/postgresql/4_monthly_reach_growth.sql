-- Purpose: Calculate monthly reach growth by campaign and identify the campaign with the highest growth
-- Source: schema.facebook_ads_basic_daily, schema.facebook_adset, schema.facebook_campaign, schema.google_ads_basic_daily
-- Metrics: reach, monthly aggregated reach, monthly growth
-- Period: full available period in the source tables

WITH all_ads_data AS (
    SELECT 
        f.ad_date,
        c.campaign_name,
        a.adset_name,
        f.spend,
        f.impressions,
        f.reach,
        'Facebook' AS ad_source
    FROM facebook_ads_basic_daily AS f
    LEFT JOIN facebook_adset AS a 
	ON f.adset_id = a.adset_id
    LEFT JOIN facebook_campaign AS c 
	ON f.campaign_id = c.campaign_id

    UNION ALL

    SELECT 
        g.ad_date,
        g.campaign_name,
        g.adset_name,
        g.spend,
        g.impressions,
        g.reach,
        'Google' AS ad_source
    FROM google_ads_basic_daily AS g
),
monthly_reach_camp AS (
    SELECT 
        DATE_TRUNC('month', ad_date) :: DATE AS ad_month,
        campaign_name,
        COALESCE(SUM(reach), 0) AS monthly_reach
    FROM all_ads_data
    GROUP BY 1, 2
)
SELECT 
    ad_month,
    campaign_name,
    monthly_reach,
    monthly_reach - COALESCE(
	LAG(monthly_reach) OVER (PARTITION BY campaign_name ORDER BY ad_month), 0) AS monthly_growth
FROM monthly_reach_camp
ORDER BY monthly_growth DESC
LIMIT 1;
