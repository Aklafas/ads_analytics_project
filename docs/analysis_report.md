# Report on Advertising Campaign and User Behavior Analysis

## Context
This project analyzes the effectiveness of advertising campaigns on Facebook and Google, as well as user behavior on a website based on Google Analytics 4 data processed through BigQuery.
The goal was to identify which campaigns generate the most value and to understand user interactions on the site in order to improve conversion.

## Метод
Advertising data: calculated daily spend (average, min, max), top ROMI days, campaign-level revenue and reach.

User behavior: analyzed conversion funnel (session → product view → add to cart → checkout → purchase), page-level conversion, and correlation between engagement metrics and purchases.

## Results
- Facebook daily spend reached a maximum of $2,266, while Google averaged only $199.

- The most effective day by ROMI was January 11, 2022, with ROMI = 1.49.

- The campaign “Expansion” generated the highest total revenue ($2,294,120), while “Hobbies” showed strong monthly growth in reach (+4.2M users).

- The longest-running campaign set was “Wide” on Facebook (50 days).

- Funnel analysis showed only 2% of organic sessions on January 31, 2021 reached checkout.

- The product page /Google+Redesign/Bags/Google+Incognito+Techpack+V2 had 100% conversion, while the homepage had only 1%.

- Correlation between time on site and purchase was moderate (0.376), while engagement flag correlation was weak (0.026).

## Recommendations
- Focus ad spend on periods and campaigns with historically high ROMI (e.g., Expansion, Hobbies).

- Reallocate traffic toward high-conversion product pages instead of the homepage.

- Optimize the checkout process to reduce funnel drop-offs.

- Monitor long-term campaigns for sustained effectiveness (e.g., “Wide”).

## Limitations
- Data comes only from Facebook, Google Ads, and GA4; it does not include other channels (e.g., email, referral).

- Seasonal and external factors may influence campaign results.

- Correlation findings do not imply causation; further A/B testing is needed.
