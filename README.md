# <PROJECT_NAME> — Advertising Analytics (Google & Facebook) and E-commerce Pages

Analysis of advertising campaigns and e-commerce pages, answering business questions such as campaign efficiency, user behavior on site, and key insights obtained.

## 🧰 Tech Stack
- SQL: PostgreSQL, BigQuery
- BI: Looker Studio

## 📂 Project Structure
```
.
├── README.md
├── sql/
│   ├── postgresql/           # 5 queries for advertising campaigns
│   └── bigquery/             # 4 queries for e-commerce pages
├── dashboards/
│   ├── notebooks/            # notebooks with charts/metrics
│   └── screenshots/          # dashboard screenshots
├── docs/
│   └── analysis_report.md    # textual report
├── data/                     # local data (.gitignore)
│   ├── raw/
│   └── processed/
├── .gitignore
├── requirements.txt
├── .sqlfluff
└── .pre-commit-config.yaml
```

## 🎯 Goals & Metrics
- Advertising: CTR, CPC, CPA/ROAS, conversions by campaigns/creatives/audiences
- E-commerce pages: page view → add to cart → purchase (funnel), time on page, speed, exits

## 🚀 Quick Start
1. Clone/unpack the template and rename the folder for your project.
2. Place your SQL files in sql/postgresql and sql/bigquery. Follow naming convention 01_...sql, 02_...sql, etc.
3. (Optional) Install dependencies: pip install -r requirements.txt and run notebooks.
4. Capture dashboards (links/screenshots) in dashboards/.
5. Document results in docs/analysis_report.md.

## 🧹 SQL Style
- Keywords in UPPERCASE
- Clear aliases, CTEs for logical steps
- Formatting validation via sqlfluff

## ✅ Results
1. Advertising (Google & Facebook):
- Campaign X showed the highest CTR of 5.2%, while the cost per click was lower than average.
- Video ad creatives have 30% more conversions than static banners.
- Google Search ROI is higher than Facebook, with comparable costs.

2. E-commerce pages:
- The “Product A” page has the highest percentage of conversion from viewing to adding to cart (25%).
- Average time on page is positively correlated with the likelihood of purchase (correlation coefficient 0.45).
- The longest consistent user activity is observed on the “Electronics” category page.

## License
This project is for educational purposes only.
