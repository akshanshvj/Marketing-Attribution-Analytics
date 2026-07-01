# Power BI Star Schema Data Model

This directory contains the star schema tables generated from the cleaned marketing campaign dataset, optimized for direct loading into Power BI.

---

## 🏗️ Schema Overview

The schema is structured as a **Star Schema** with one central fact table and six supporting dimension tables. Surrogate keys have been generated for each dimension, and all text descriptors in the fact table have been replaced with these integer keys to improve BI join performance.

```mermaid
erDiagram
    fact_marketing_campaigns {
        varchar campaign_id PK
        int brand_id FK
        int channel_id FK
        int campaign_type_id FK
        int customer_segment_id FK
        int language_id FK
        int date_key FK
        varchar target_audience
        int duration
        int impressions
        int clicks
        int leads
        int conversions
        decimal revenue
        decimal acquisition_cost
        decimal roi
        decimal engagement_score
        decimal ctr
        decimal conversion_rate
        decimal cpc
        decimal cpl
        decimal cpa
        decimal revenue_per_conversion
    }
    dim_brand {
        int brand_id PK
        varchar brand
    }
    dim_channel {
        int channel_id PK
        varchar channel_used
    }
    dim_campaign_type {
        int campaign_type_id PK
        varchar campaign_type
    }
    dim_customer_segment {
        int customer_segment_id PK
        varchar customer_segment
    }
    dim_language {
        int language_id PK
        varchar language
    }
    dim_date {
        int date_key PK
        date date
        int year
        int quarter
        int month_number
        varchar month_name
        int week_number
        int day
        varchar day_name
        int weekend_flag
    }
    
    fact_marketing_campaigns }|--|| dim_brand : "brand_id"
    fact_marketing_campaigns }|--|| dim_channel : "channel_id"
    fact_marketing_campaigns }|--|| dim_campaign_type : "campaign_type_id"
    fact_marketing_campaigns }|--|| dim_customer_segment : "customer_segment_id"
    fact_marketing_campaigns }|--|| dim_language : "language_id"
    fact_marketing_campaigns }|--|| dim_date : "date_key"
```

---

## 🗂️ Tables Summary

### 1. `fact_marketing_campaigns`
*   **Description:** The central transaction table containing numerical measurements (impressions, clicks, conversions, revenue, cost) and metric ratios (CTR, CPA, ROI), mapped to dimensions via surrogate keys.
*   **Row Count:** 166,665
*   **Column Count:** 23

### 2. `dim_brand`
*   **Description:** Brand portfolio details (Nykaa, Purplle, Tira).
*   **Row Count:** 3
*   **Column Count:** 2

### 3. `dim_channel`
*   **Description:** Bidding channels and multi-channel configurations (e.g. Email, Instagram, Facebook + combos).
*   **Row Count:** 156
*   **Column Count:** 2

### 4. `dim_campaign_type`
*   **Description:** Campaign strategy classifications (Paid Ads, Social Media, Influencer, SEO, Email).
*   **Row Count:** 5
*   **Column Count:** 2

### 5. `dim_customer_segment`
*   **Description:** Buyer demographic segments (College Students, Youth, Working Women, Premium Shoppers, Tier 2 City Customers).
*   **Row Count:** 5
*   **Column Count:** 2

### 6. `dim_language`
*   **Description:** localized languages utilized in copy (Bengali, English, Hindi, Tamil).
*   **Row Count:** 4
*   **Column Count:** 2

### 7. `dim_date`
*   **Description:** The calendar dimension generated dynamically from the date boundaries in the raw logs.
*   **Attributes:** Date, Year, Quarter, Month Number, Month Name, Week Number, Day, Day Name, Weekend Flag.
*   **Row Count:** 359
*   **Column Count:** 10
