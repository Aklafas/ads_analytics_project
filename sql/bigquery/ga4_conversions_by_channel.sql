-- Purpose: Build a funnel analysis by traffic source, medium, and campaign to measure user progression from visits to purchase
-- Source: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131
-- Metrics: user sessions, add-to-cart count, checkout count, purchase count, visit-to-cart rate, visit-to-checkout rate, visit-to-purchase rate
-- Period: 2021-01-31

WITH sessions AS (
  SELECT
    DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_date,
    user_pseudo_id,
    (
      SELECT 
        value.int_value
      FROM UNNEST(event_params)
      WHERE key = "ga_session_id"
    ) AS session_id,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign,
    event_name
  FROM bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131
  WHERE event_name IN ("session_start","add_to_cart","begin_checkout","purchase")
),
user_sessions AS (
  SELECT
    event_date,
    user_pseudo_id,
    session_id,
    source,
    medium,
    campaign,
    CONCAT(user_pseudo_id, "-", session_id) AS user_session_id,
    event_name
  FROM sessions
)
SELECT
  event_date,
  source,
  medium,
  campaign,
  COUNT(DISTINCT user_session_id) AS user_sessions_count,
  COUNT(DISTINCT CASE WHEN event_name = "add_to_cart" THEN user_session_id END) AS added_to_cart_count,
  COUNT(DISTINCT CASE WHEN event_name = "begin_checkout" THEN user_session_id END) AS began_checkout_count,
  COUNT(DISTINCT CASE WHEN event_name = "purchase" THEN user_session_id END) AS purchased_count,
  ROUND(SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN event_name = "add_to_cart" THEN user_session_id END),
    COUNT(DISTINCT user_session_id)
  ), 2) AS visit_to_cart,
  ROUND(SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN event_name = "begin_checkout" THEN user_session_id END),
    COUNT(DISTINCT user_session_id)
  ), 2) AS visit_to_checkout,
  ROUND(SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN event_name = "purchase" THEN user_session_id END),
    COUNT(DISTINCT user_session_id)
  ), 2) AS visit_to_purchase
FROM user_sessions
WHERE event_name IN ("session_start","add_to_cart","begin_checkout","purchase")
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4;