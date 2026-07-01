-- ============================================================================
-- SQL Portfolio Project: Marketing Attribution & Campaign Analytics
-- File: functions.sql
-- Description: Reusable PostgreSQL PL/pgSQL stored functions for reporting.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Function: get_top_campaigns
-- Description: Retrieves the top N campaigns based on gross revenue.
-- Parameters: limit_count (integer) - Maximum number of rows to return.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_top_campaigns(limit_count integer)
RETURNS TABLE (
    campaign_id VARCHAR(50),
    brand VARCHAR(50),
    campaign_type VARCHAR(50),
    revenue DECIMAL(15, 2),
    roi DECIMAL(12, 4)
) AS $$
BEGIN
    -- Return query matches table signature
    RETURN QUERY
    SELECT mc.campaign_id, mc.brand, mc.campaign_type, mc.revenue, mc.roi
    FROM marketing_campaigns mc
    ORDER BY mc.revenue DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_top_campaigns(integer) IS 'Returns the top N campaigns by gross revenue.';

-- ----------------------------------------------------------------------------
-- Function: get_brand_revenue
-- Description: Retrieves the monthly revenue and conversions breakdown 
--              for a specific brand portfolio (case-insensitive).
-- Parameters: brand_name (text) - Name of the brand (e.g. 'Nykaa').
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_brand_revenue(brand_name text)
RETURNS TABLE (
    campaign_month DATE,
    monthly_revenue DECIMAL(15, 2),
    monthly_conversions INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT DATE_TRUNC('month', mc.date)::DATE AS campaign_month,
           SUM(mc.revenue) AS monthly_revenue,
           SUM(mc.conversions)::INT AS monthly_conversions
    FROM marketing_campaigns mc
    WHERE LOWER(mc.brand) = LOWER(brand_name)
    GROUP BY DATE_TRUNC('month', mc.date)::DATE
    ORDER BY campaign_month ASC;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_brand_revenue(text) IS 'Returns chronological monthly revenue breakdown for a specific brand.';

-- ----------------------------------------------------------------------------
-- Function: get_monthly_revenue
-- Description: Retrieves all campaigns that ran during a specific calendar 
--              month and year, sorted by gross revenue.
-- Parameters: month_input (date) - Any date within the target month.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_monthly_revenue(month_input date)
RETURNS TABLE (
    campaign_id VARCHAR(50),
    brand VARCHAR(50),
    campaign_type VARCHAR(50),
    revenue DECIMAL(15, 2),
    roi DECIMAL(12, 4)
) AS $$
BEGIN
    RETURN QUERY
    SELECT mc.campaign_id, mc.brand, mc.campaign_type, mc.revenue, mc.roi
    FROM marketing_campaigns mc
    WHERE DATE_TRUNC('month', mc.date) = DATE_TRUNC('month', month_input)
    ORDER BY mc.revenue DESC;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_monthly_revenue(date) IS 'Returns all campaigns executed in the target month sorted by revenue.';

-- ----------------------------------------------------------------------------
-- Function: get_best_channels
-- Description: Retrieves the top N marketing channels ranked by average ROI.
-- Parameters: limit_count (integer) - Maximum number of channels to return.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_best_channels(limit_count integer)
RETURNS TABLE (
    channel_used VARCHAR(255),
    average_roi DECIMAL(12, 4),
    total_revenue DECIMAL(15, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT mc.channel_used,
           AVG(mc.roi)::DECIMAL(12, 4) AS average_roi,
           SUM(mc.revenue) AS total_revenue
    FROM marketing_campaigns mc
    GROUP BY mc.channel_used
    ORDER BY average_roi DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_best_channels(integer) IS 'Returns the top N channels based on average ROI.';
