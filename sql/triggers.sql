-- ============================================================================
-- SQL Portfolio Project: Marketing Attribution & Campaign Analytics
-- File: triggers.sql
-- Description: Automated database trigger for KPI calculation on write.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Trigger Function: fn_calculate_campaign_kpis
-- Purpose: Automatically computes CTR, Conversion_Rate, CPC, CPL, CPA, and 
--          Revenue_Per_Conversion before rows are inserted or updated. 
--          This keeps data integrity and handles divide-by-zero safely.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_calculate_campaign_kpis()
RETURNS TRIGGER AS $$
BEGIN
    -- 1. Click-Through Rate (CTR)
    IF NEW.impressions > 0 THEN
        NEW.ctr := (NEW.clicks::DECIMAL / NEW.impressions) * 100.0;
    ELSE
        NEW.ctr := 0.000000;
    END IF;

    -- 2. Conversion Rate & Cost Per Click (CPC)
    IF NEW.clicks > 0 THEN
        NEW.conversion_rate := (NEW.conversions::DECIMAL / NEW.clicks) * 100.0;
        NEW.cpc := NEW.acquisition_cost / NEW.clicks;
    ELSE
        NEW.conversion_rate := 0.000000;
        NEW.cpc := 0.000000;
    END IF;

    -- 3. Cost Per Lead (CPL)
    IF NEW.leads > 0 THEN
        NEW.cpl := NEW.acquisition_cost / NEW.leads;
    ELSE
        NEW.cpl := 0.000000;
    END IF;

    -- 4. Cost Per Acquisition (CPA) & Revenue Per Conversion
    IF NEW.conversions > 0 THEN
        NEW.cpa := NEW.acquisition_cost / NEW.conversions;
        NEW.revenue_per_conversion := NEW.revenue / NEW.conversions;
    ELSE
        NEW.cpa := 0.000000;
        NEW.revenue_per_conversion := 0.000000;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_calculate_campaign_kpis() IS 'Trigger function to compute rate and unit-cost KPIs on insert/update.';

-- ----------------------------------------------------------------------------
-- Trigger: trg_marketing_kpis
-- Scope: Row-level trigger firing BEFORE INSERT OR UPDATE on marketing_campaigns.
-- ----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_marketing_kpis ON marketing_campaigns;

CREATE TRIGGER trg_marketing_kpis
BEFORE INSERT OR UPDATE
ON marketing_campaigns
FOR EACH ROW
EXECUTE FUNCTION fn_calculate_campaign_kpis();
