-- Purpose: Analyze conversion rates by landing page path based on GA4 sample e-commerce dataset
-- Source: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131
-- Metrics: unique sessions, add-to-cart sessions, conversion rate
-- Period: 2021-01-31

WITH sessions AS (
  SELECT
    user_pseudo_id,
    (
      SELECT
        value.int_value 
      FROM UNNEST(event_params) 
      WHERE key = "ga_session_id") AS session_id,
      REGEXP_EXTRACT(
        (SELECT 
          value.string_value 
        FROM UNNEST(event_params) 
        WHERE key = "page_location"),
      r"https?://[^/]+([^?#]+)"
    ) AS page_path
  FROM bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131
  WHERE event_name = "session_start"
),
purchases AS (
  SELECT
    user_pseudo_id,
    (SELECT
      value.int_value 
    FROM UNNEST(event_params)
    WHERE key = "ga_session_id"
    ) AS session_id,
  FROM bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131
  WHERE event_name = "purchase"
),
joined AS (
  SELECT
    s.page_path,
    CONCAT(s.user_pseudo_id, "-", s.session_id) AS session_key,
    IF(a.session_id IS NOT NULL, 1, 0) AS has_add_to_cart
  FROM sessions AS s
  LEFT JOIN purchases AS a
    ON s.user_pseudo_id = a.user_pseudo_id
    AND s.session_id = a.session_id
)
SELECT
  page_path,
  COUNT(DISTINCT session_key) AS unique_sessions,
  COUNT(DISTINCT IF(has_add_to_cart = 1, session_key, NULL)) AS add_to_cart_sessions,
  ROUND(
    SAFE_DIVIDE(
      COUNT(DISTINCT IF(has_add_to_cart = 1, session_key, NULL)),
      COUNT(DISTINCT session_key)
  ), 2) AS conversion
FROM joined
GROUP BY 1
ORDER BY conversion DESC;
