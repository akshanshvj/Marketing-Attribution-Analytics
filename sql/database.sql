-- ============================================================================
-- SQL Portfolio Project: Marketing Attribution & Campaign Analytics
-- File: database.sql
-- Description: Enterprise-grade database initialization for PostgreSQL.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- CRITICAL WARNING ON DESTRUCTIVE OPERATIONS
-- ----------------------------------------------------------------------------
-- The command below drops the database 'marketing_db' and all associated tables, 
-- schemas, and functions. This should only be executed in a development or 
-- sandbox environment during initial setups. Do NOT run this in production!
-- ----------------------------------------------------------------------------

-- Drop the database if it already exists to allow for a clean schema re-run
DROP DATABASE IF EXISTS marketing_db;

-- Create the database with standard UTF8 encoding and default parameters
CREATE DATABASE marketing_db 
    WITH 
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

-- Connect to the newly created database (psql CLI command)
-- This directive ensures that all subsequent scripts (create_table, views, triggers)
-- execute inside the context of the correct database catalog.
\c marketing_db;

-- Add confirmation comment
COMMENT ON DATABASE marketing_db IS 'Analytical warehouse database for multi-brand marketing attribution campaigns.';
