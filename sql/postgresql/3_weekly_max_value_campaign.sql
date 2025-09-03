-- Purpose: Identify the campaign with the maximum total value per week across Facebook and Google Ads
-- Source: schema.facebook_ads_basic_daily, schema.facebook_adset, schema.facebook_campaign, schema.google_ads_basic_daily
-- Metrics: spend, value, impressions, reach, weekly aggregated value
-- Period: full available period in the source tables

WITH all_ads_data AS (
    SELECT 
        f.ad_date,
        c.campaign_name,
        a.adset_name,
        f.spend,
        f.value,
        f.impressions,
        f.reach,
        'Facebook' AS ad_source
    FROM facebook_ads_basic_daily f
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
        g.value,
        g.impressions,
        g.reach,
        'Google' AS ad_source
    FROM google_ads_basic_daily AS g
)

SELECT 
    DATE_TRUNC('week', ad_date) :: DATE AS week_start,
    campaign_name,
    SUM(value) AS weekly_value
FROM all_ads_data
GROUP BY 1, 2
HAVING SUM(value) > 0
ORDER BY weekly_value DESC
LIMIT 1;