-- Purpose: Aggregate and compare spend statistics across Facebook and Google Ads campaigns
-- Source: schema.facebook_ads_basic_daily, schema.google_ads_basic_daily
-- Metrics: average spend, maximum spend, minimum spend
-- Period: full available period in the source tables

SELECT
    ad_date,
    source,
    AVG(spend) AS avg_spend,
    MAX(spend) AS max_spend,
    MIN(spend) AS min_spend
FROM (
    SELECT
	ad_date, 
	'Facebook' :: TEXT AS source,
	spend, 
	impressions, 
	reach, 
	clicks, 
	leads, 
	value
    FROM facebook_ads_basic_daily
	
    UNION ALL
	
    SELECT 
	ad_date,
	'Google' :: TEXT AS platform,
	spend, 
	impressions, 
	reach, 
	clicks, 
	leads, 
	value
    FROM google_ads_basic_daily
) AS agr_table
GROUP BY 1, 2
ORDER BY 1, 2;