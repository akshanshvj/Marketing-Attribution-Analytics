-- ============================================================================
-- SQL Portfolio Project: Marketing Attribution & Campaign Analytics
-- File: views.sql
-- Description: Analytical database views for business intelligence reporting.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- View: vw_brand_summary
-- Purpose: Aggregates top-line sales, campaign ROI, engagement, and conversion 
--          metrics across Nykaa, Purplle, and Tira brand portfolios.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_brand_summary AS
SELECT brand,
       SUM(revenue) AS total_revenue,
       AVG(roi) AS average_roi,
       AVG(ctr) AS average_ctr,
       AVG(cpa) AS average_cpa,
       AVG(conversion_rate) AS average_conversion_rate,
       SUM(acquisition_cost * conversions) AS total_acquisition_cost
FROM marketing_campaigns
GROUP BY brand;

COMMENT ON VIEW vw_brand_summary IS 'BI View: Aggregated performance metrics by brand portfolio.';

-- ----------------------------------------------------------------------------
-- View: vw_channel_summary
-- Purpose: Summarizes cost efficiency and gross returns for each marketing channel
--          (e.g., Email, Instagram, Facebook, and combinations).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_channel_summary AS
SELECT channel_used,
       SUM(revenue) AS total_revenue,
       SUM(conversions) AS total_conversions,
       AVG(cpc) AS average_cpc,
       AVG(cpa) AS average_cpa,
       AVG(roi) AS average_roi
FROM marketing_campaigns
GROUP BY channel_used;

COMMENT ON VIEW vw_channel_summary IS 'BI View: Channel effectiveness and acquisition cost summary.';

-- ----------------------------------------------------------------------------
-- View: vw_monthly_summary
-- Purpose: Evaluates chronological and seasonal trends by tracking monthly
--          revenue, average campaign returns, and transaction volumes.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_monthly_summary AS
SELECT DATE_TRUNC('month', date) AS campaign_month,
       SUM(revenue) AS monthly_revenue,
       AVG(roi) AS monthly_average_roi,
       SUM(conversions) AS monthly_conversions
FROM marketing_campaigns
GROUP BY campaign_month;

COMMENT ON VIEW vw_monthly_summary IS 'BI View: Monthly time-series trend tracker for revenue, ROI, and conversions.';

-- ----------------------------------------------------------------------------
-- View: vw_campaign_performance
-- Purpose: Detailed raw list of campaign metrics to feed into visual dashboards.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_campaign_performance AS
SELECT campaign_id,
       brand,
       campaign_type,
       channel_used,
       revenue,
       roi,
       ctr,
       cpa
FROM marketing_campaigns;

COMMENT ON VIEW vw_campaign_performance IS 'BI View: Granular campaign attribution listing for visual dashboards.';
