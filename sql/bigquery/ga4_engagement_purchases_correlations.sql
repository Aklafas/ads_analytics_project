-- Purpose: Analyze correlation between session engagement and purchase behavior in GA4 sample e-commerce dataset
-- Source: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131
-- Metrics: session_engaged_flag, total_engagement_time, purchase_flag, correlation coefficients
-- Period: 2021-01-31

WITH data_table AS (
  SELECT
    user_pseudo_id,
      (SELECT 
        value.int_value 
      FROM UNNEST(event_params) 
      WHERE key = "ga_session_id"
      ) AS session_id,
      MAX(
        CAST(
          (SELECT 
            value.string_value
           FROM UNNEST(event_params) 
           WHERE key = "session_engaged"
          ) AS INTEGER
        )
      ) AS session_engaged_flag,
      SUM(
        COALESCE(
          (SELECT value.int_value FROM UNNEST(event_params) WHERE key = "engagement_time_msec"),
          0
        )
      ) AS total_engagement_time,
    MAX(CASE WHEN event_name = "purchase" THEN 1 ELSE 0 END) AS purchase_flag
  FROM bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131
  GROUP BY 1, 2
)
SELECT
  ROUND(CORR(session_engaged_flag, purchase_flag), 3) AS corr_engaged_purchase,
  ROUND(CORR(total_engagement_time, purchase_flag), 3) AS corr_time_purchase
FROM data_table;
