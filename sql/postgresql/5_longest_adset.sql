-- Purpose: Identify the longest consecutive activity streak (by ad set and source) across Facebook and Google Ads
-- Source: schema.facebook_ads_basic_daily, schema.facebook_adset, schema.facebook_campaign, schema.google_ads_basic_daily
-- Metrics: activity streak length (days_count), start_date, end_date
-- Period: full available period in the source tables

WITH all_ads_data AS (
    SELECT 
        f.ad_date,
        a.adset_name,
        c.campaign_name,
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
        g.adset_name,
        g.campaign_name,
        g.spend,
        g.impressions,
        g.reach,
        'Google' AS ad_source
    FROM google_ads_basic_daily AS g
),
ranked_ad_set_days AS (
    SELECT 
        adset_name,
        ad_source,
        ad_date,
        ROW_NUMBER() OVER (PARTITION BY adset_name, ad_source ORDER BY ad_date) AS rn
    FROM all_ads_data
),
grouped_data AS (
    SELECT 
        adset_name,
        ad_source,
        ad_date,
        ad_date - rn * INTERVAL '1 day' AS grp
    FROM ranked_ad_set_days
),
all_streaks AS (
    SELECT 
        adset_name,
        ad_source,
        MIN(ad_date) AS start_date,
        MAX(ad_date) AS end_date,
        COUNT(*) AS days_count
    FROM grouped_data
    GROUP BY 1, 2, grp
)
SELECT *
FROM all_streaks
ORDER BY days_count DESC
LIMIT 1;
