-- ==========================================
-- DEFAULT DATA INSERTION
-- ==========================================
-- This script inserts default/sample data
-- Run this AFTER creating tables (01_create_tables.sql)

-- ==========================================
-- NOTE: This is optional for testing
-- In production, users will register themselves
-- ==========================================

-- No default data needed for theme_config
-- Themes are created when users customize their preferences

-- Success message
SELECT 'Default data setup complete!' as Message;
SELECT 'Users can now register via the signup page' as Note;
