-- Purpose: Extract detailed event-level data for key e-commerce actions from GA4 sample dataset
-- Source: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131
-- Metrics: event timestamp, user ID, session ID, event name, country, device category, traffic source, medium, campaign
-- Period: 2021-01-31

SELECT
  TIMESTAMP_MICROS(event_timestamp) AS event_timestamp,
  user_pseudo_id,
  (
    SELECT
      value.int_value,
    FROM UNNEST(event_params)
    WHERE key = "ga_session_id" 
  ) AS session_id,
  event_name,
  geo.country AS country,
  device.category AS device_category,
  traffic_source.source AS source,
  traffic_source.medium AS medium,
  traffic_source.name AS campaign
FROM bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131 
WHERE event_name IN (
  "session_start",
  "view_item",
  "add_to_cart",
  "begin_checkout",
  "purchase"
)
ORDER BY 1;
