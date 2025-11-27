-- ==========================================
-- SAMPLE RESOURCES DATA (OPTIONAL)
-- ==========================================
-- This script inserts sample resources for testing
-- CHANGE ACCORDINGLY: Update user_id to match your admin user ID

-- ==========================================
-- IMPORTANT NOTES
-- ==========================================
-- 1. Run this ONLY for testing/demo purposes
-- 2. CHANGE ACCORDINGLY: Replace user_id with actual user ID
-- 3. In production, users will create resources via the UI

-- ==========================================
-- CHECK USER ID FIRST
-- ==========================================
-- Find your admin user ID
SELECT id, email, full_name FROM users WHERE role = 'admin';

-- Copy the ID from above and use it below
-- ==========================================

-- CHANGE ACCORDINGLY: Replace '1' with actual admin user ID from above query

-- Sample Virtual Machines
INSERT INTO resources (name, type, status, region, cpu_usage, memory_usage, storage_usage, network_usage, description, user_id)
VALUES 
('Production Web Server', 'Virtual Machine', 'active', 'Southeast Asia', 45.5, 62.3, 38.7, 25.4, 'Main application server hosting web services', 1),
('Database Server', 'Virtual Machine', 'active', 'Southeast Asia', 62.8, 75.2, 55.1, 42.3, 'Primary SQL database server', 1),
('Dev Test Server', 'Virtual Machine', 'inactive', 'East US', 12.5, 25.8, 15.2, 8.5, 'Development and testing environment', 1);

-- Sample Databases
INSERT INTO resources (name, type, status, region, cpu_usage, memory_usage, storage_usage, network_usage, description, user_id)
VALUES 
('User Database', 'Azure SQL Database', 'active', 'Southeast Asia', 35.2, 48.6, 62.3, 28.7, 'Production user data storage', 1),
('Analytics DB', 'Azure SQL Database', 'active', 'East US', 58.3, 65.4, 78.2, 45.8, 'Analytics and reporting database', 1),
('Backup DB', 'Azure SQL Database', 'pending', 'West Europe', 5.2, 12.3, 25.6, 3.2, 'Disaster recovery backup database', 1);

-- Sample Storage Accounts
INSERT INTO resources (name, type, status, region, cpu_usage, memory_usage, storage_usage, network_usage, description, user_id)
VALUES 
('Media Storage', 'Storage Account', 'active', 'Southeast Asia', 0, 0, 82.5, 35.6, 'User uploaded media and assets', 1),
('Backup Storage', 'Storage Account', 'active', 'West Europe', 0, 0, 45.2, 12.3, 'Automated backup storage', 1);

-- Sample Load Balancers
INSERT INTO resources (name, type, status, region, cpu_usage, memory_usage, storage_usage, network_usage, description, user_id)
VALUES 
('Public Load Balancer', 'Load Balancer', 'active', 'Southeast Asia', 28.5, 32.4, 0, 68.5, 'Distributes traffic across web servers', 1);

-- Sample Virtual Networks
INSERT INTO resources (name, type, status, region, cpu_usage, memory_usage, storage_usage, network_usage, description, user_id)
VALUES 
('Production VNet', 'Virtual Network', 'active', 'Southeast Asia', 0, 0, 0, 45.2, 'Main production network', 1),
('Dev VNet', 'Virtual Network', 'active', 'East US', 0, 0, 0, 15.8, 'Development environment network', 1);

-- ==========================================
-- VERIFY SAMPLE DATA
-- ==========================================

-- Check total resources created
SELECT COUNT(*) as TotalResources FROM resources;

-- Check resources by type
SELECT type, COUNT(*) as Count 
FROM resources 
GROUP BY type 
ORDER BY Count DESC;

-- Check resources by status
SELECT status, COUNT(*) as Count 
FROM resources 
GROUP BY status;

-- View all resources
SELECT 
    id,
    name,
    type,
    status,
    region,
    cpu_usage,
    memory_usage,
    created_at
FROM resources
ORDER BY created_at DESC;

-- ==========================================
-- CLEAN UP (If needed)
-- ==========================================
-- Uncomment below to delete all sample resources
-- DELETE FROM resources WHERE user_id = 1;
