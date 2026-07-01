-- ============================================================================
-- SQL Portfolio Project: Marketing Attribution & Campaign Analytics
-- File: create_table.sql
-- Description: Enterprise-grade PostgreSQL schema definition with data integrity
--              constraints, column-level metadata, and query indexes.
-- ============================================================================

-- Create the consolidated marketing campaigns warehouse table
CREATE TABLE marketing_campaigns (
    -- Unique Identifiers
    campaign_id VARCHAR(50) PRIMARY KEY,
    
    -- Campaign Characteristics
    campaign_type VARCHAR(50) NOT NULL,
    target_audience VARCHAR(100) NOT NULL,
    duration INT NOT NULL CHECK (duration > 0),
    channel_used VARCHAR(255) NOT NULL,
    
    -- High-Level Funnel Metrics (Non-negative)
    impressions INT NOT NULL CHECK (impressions >= 0),
    clicks INT NOT NULL CHECK (clicks >= 0),
    leads INT NOT NULL CHECK (leads >= 0),
    conversions INT NOT NULL CHECK (conversions >= 0),
    
    -- Financial Metrics (INR, non-negative except ROI which allows losses)
    revenue DECIMAL(15, 2) NOT NULL CHECK (revenue >= 0.00),
    acquisition_cost DECIMAL(15, 2) NOT NULL CHECK (acquisition_cost >= 0.00),
    roi DECIMAL(12, 4) NOT NULL,
    
    -- Audience Metadata
    language VARCHAR(50) NOT NULL,
    engagement_score DECIMAL(5, 2) NOT NULL CHECK (engagement_score >= 0.00),
    customer_segment VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    brand VARCHAR(50) NOT NULL,
    
    -- Pre-calculated / Trigger-calculated KPIs
    ctr DECIMAL(10, 6) NOT NULL CHECK (ctr >= 0.000000),
    conversion_rate DECIMAL(10, 6) NOT NULL CHECK (conversion_rate >= 0.000000),
    cpc DECIMAL(15, 6) NOT NULL CHECK (cpc >= 0.000000),
    cpl DECIMAL(15, 6) NOT NULL CHECK (cpl >= 0.000000),
    cpa DECIMAL(15, 6) NOT NULL CHECK (cpa >= 0.000000),
    revenue_per_conversion DECIMAL(15, 6) NOT NULL CHECK (revenue_per_conversion >= 0.000000)
);

-- ----------------------------------------------------------------------------
-- SCHEMA DOCUMENTATION (METADATA)
-- ----------------------------------------------------------------------------
COMMENT ON TABLE marketing_campaigns IS 'Consolidated marketing campaign warehouse table containing raw and KPI metrics for multi-brand analytics.';

COMMENT ON COLUMN marketing_campaigns.campaign_id IS 'Unique identifier representing a single campaign run.';
COMMENT ON COLUMN marketing_campaigns.campaign_type IS 'Strategy classification (e.g. Paid Ads, SEO, Influencer, Social Media, Email).';
COMMENT ON COLUMN marketing_campaigns.duration IS 'Active lifespan of the campaign in days.';
COMMENT ON COLUMN marketing_campaigns.channel_used IS 'Bidding channel or platform combinations utilized (e.g. Instagram, Facebook, Google).';
COMMENT ON COLUMN marketing_campaigns.impressions IS 'Total times the campaign creative was displayed to users.';
COMMENT ON COLUMN marketing_campaigns.clicks IS 'Total user click interactions captured.';
COMMENT ON COLUMN marketing_campaigns.leads IS 'Total user registrations or pipeline leads captured.';
COMMENT ON COLUMN marketing_campaigns.conversions IS 'Total purchases or bottom-funnel actions completed.';
COMMENT ON COLUMN marketing_campaigns.revenue IS 'Total gross sales revenue driven by the campaign (in INR).';
COMMENT ON COLUMN marketing_campaigns.acquisition_cost IS 'Total marketing and bidding cost spent on the campaign (in INR).';
COMMENT ON COLUMN marketing_campaigns.roi IS 'Return on Investment ratio. Computed as Net Profit / Acquisition Cost.';
COMMENT ON COLUMN marketing_campaigns.customer_segment IS 'Target demographic segment (e.g. College Students, Working Women, Premium Shoppers).';
COMMENT ON COLUMN marketing_campaigns.ctr IS 'Click-Through Rate (%) calculated as Clicks / Impressions * 100.';
COMMENT ON COLUMN marketing_campaigns.conversion_rate IS 'Conversion Rate (%) calculated as Conversions / Clicks * 100.';
COMMENT ON COLUMN marketing_campaigns.cpc IS 'Cost Per Click (INR) calculated as Acquisition Cost / Clicks.';
COMMENT ON COLUMN marketing_campaigns.cpl IS 'Cost Per Lead (INR) calculated as Acquisition Cost / Leads.';
COMMENT ON COLUMN marketing_campaigns.cpa IS 'Cost Per Acquisition (INR) calculated as Acquisition Cost / Conversions.';
COMMENT ON COLUMN marketing_campaigns.revenue_per_conversion IS 'Average revenue generated per converted transaction (INR).';

-- ----------------------------------------------------------------------------
-- INDEX DESIGN FOR QUERY OPTIMIZATION
-- ----------------------------------------------------------------------------

-- Single-column indexes for filter fields
CREATE INDEX idx_campaigns_brand ON marketing_campaigns(brand);
CREATE INDEX idx_campaigns_date ON marketing_campaigns(date);
CREATE INDEX idx_campaigns_type ON marketing_campaigns(campaign_type);
CREATE INDEX idx_campaigns_segment ON marketing_campaigns(customer_segment);

-- Multi-column index for brand trend reports (covering brand + date filter ranges)
CREATE INDEX idx_campaigns_brand_date ON marketing_campaigns(brand, date);

-- Multi-column index for efficiency analysis (covering campaign type + performance order)
CREATE INDEX idx_campaigns_type_roi ON marketing_campaigns(campaign_type, roi DESC);
