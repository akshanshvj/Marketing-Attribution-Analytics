-- ============================================================================
-- SQL Portfolio Project: Marketing Attribution & Campaign Analytics
-- File: import_data.sql
-- Description: PostgreSQL data ingestion commands for loading campaign data.
-- ============================================================================

-- This script contains directives for PostgreSQL data loading. All MySQL instructions 
-- have been removed to comply with warehouse design standards.

-- Ensure you have connected to marketing_db prior to running these commands.
-- \c marketing_db;

-- ----------------------------------------------------------------------------
-- OPTION A: PostgreSQL Server-Side COPY Command (Superuser Only)
-- ----------------------------------------------------------------------------
-- Use this if you are running SQL commands directly on the server instance where
-- the file is locally accessible. 
-- Note: Replace '/absolute/path/to/marketing_data_cleaned.csv' with the actual 
-- absolute file system path of the cleaned data file.

-- COPY marketing_campaigns (
--     campaign_id, campaign_type, target_audience, duration, channel_used,
--     impressions, clicks, leads, conversions, revenue, acquisition_cost, roi,
--     language, engagement_score, customer_segment, date, brand,
--     ctr, conversion_rate, cpc, cpl, cpa, revenue_per_conversion
-- )
-- FROM '/absolute/path/to/Marketing-Attribution-Analytics/data/marketing_data_cleaned.csv'
-- DELIMITER ','
-- CSV HEADER
-- ENCODING 'UTF8';


-- ----------------------------------------------------------------------------
-- OPTION B: PostgreSQL Client-Side \copy Command (Recommended)
-- ----------------------------------------------------------------------------
-- Use this inside the psql CLI client. This command runs with client privileges
-- and streams the CSV file from your local folder directly to the PostgreSQL database.
-- Run this command from the workspace root directory:

-- \copy marketing_campaigns FROM 'data/marketing_data_cleaned.csv' WITH (FORMAT csv, HEADER true, ENCODING 'utf-8', DELIMITER ',');
