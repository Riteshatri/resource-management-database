-- ==========================================
-- BACKUP AND RESTORE COMMANDS
-- ==========================================
-- Azure SQL Database automatic backup and restore guide

-- ==========================================
-- IMPORTANT NOTES
-- ==========================================
-- 1. Azure SQL automatically backs up databases
-- 2. Point-in-time restore available for last 7-35 days (based on tier)
-- 3. Use Azure Portal for easiest backup/restore experience
-- 4. These are reference commands and notes

-- ==========================================
-- AUTOMATED BACKUPS (Azure SQL)
-- ==========================================
-- Azure SQL automatically takes:
-- - Full backups: Weekly
-- - Differential backups: Every 12-24 hours  
-- - Transaction log backups: Every 5-10 minutes

-- Retention periods:
-- Basic tier: 7 days
-- Standard/Premium: 35 days
-- Can be configured up to 10 years with long-term retention

-- ==========================================
-- MANUAL EXPORT (Azure Portal)
-- ==========================================
-- 1. Go to Azure Portal > SQL Databases > Your Database
-- 2. Click "Export" in top menu
-- 3. Configure:
--    - Storage account (CHANGE ACCORDINGLY)
--    - Container name (CHANGE ACCORDINGLY)
--    - Blob name: backup-YYYYMMDD.bacpac
--    - Authentication: SQL authentication
--    - Server admin login (CHANGE ACCORDINGLY)
--    - Password (CHANGE ACCORDINGLY)
-- 4. Click "OK"
-- 5. Download .bacpac file from blob storage

-- ==========================================
-- POINT-IN-TIME RESTORE (Azure Portal)
-- ==========================================
-- Restore to specific timestamp within retention period

-- Steps:
-- 1. Go to Azure Portal > SQL Databases > Your Database
-- 2. Click "Restore" in top menu
-- 3. Configure:
--    - Restore point: Select date/time
--    - Database name: restored-database-name (CHANGE ACCORDINGLY)
--    - Server: Same or different server
--    - Pricing tier: Choose tier
-- 4. Click "OK"
-- 5. Wait for restore to complete (5-30 minutes)

-- ==========================================
-- IMPORT DATABASE (Azure Portal)
-- ==========================================
-- Restore from .bacpac file

-- Steps:
-- 1. Upload .bacpac to Azure Blob Storage
-- 2. Go to Azure Portal > SQL Server > Your Server
-- 3. Click "Import database"
-- 4. Configure:
--    - Storage account (CHANGE ACCORDINGLY)
--    - Blob container (CHANGE ACCORDINGLY)
--    - .bacpac file (CHANGE ACCORDINGLY)
--    - Database name (CHANGE ACCORDINGLY)
--    - Pricing tier
--    - Server admin credentials
-- 5. Click "OK"
-- 6. Wait for import (10-60 minutes depending on size)

-- ==========================================
-- EXPORT SPECIFIC TABLES (Manual Backup)
-- ==========================================
-- For selective data backup

-- Export users table
SELECT * FROM users;
-- Copy results and save as CSV

-- Export resources table  
SELECT * FROM resources;
-- Copy results and save as CSV

-- Export theme_config table
SELECT * FROM theme_config;
-- Copy results and save as CSV

-- ==========================================
-- VERIFY BACKUP EXISTS
-- ==========================================
-- Check database restore points

-- Run in Azure Cloud Shell or Azure CLI:
-- az sql db show --resource-group YOUR-RESOURCE-GROUP --server YOUR-SERVER --name YOUR-DATABASE
-- (CHANGE ACCORDINGLY: Replace with actual resource group, server, and database names)

-- ==========================================
-- DISASTER RECOVERY CHECKLIST
-- ==========================================
-- □ Automated backups enabled (default in Azure SQL)
-- □ Backup retention period configured
-- □ Geo-replication set up (for critical systems)
-- □ Tested restore process
-- □ Documented restore procedures
-- □ Admin credentials stored securely
-- □ Storage account for manual exports configured

-- ==========================================
-- BACKUP BEST PRACTICES
-- ==========================================
-- 1. Test restore process monthly
-- 2. Keep exported .bacpac files in separate region
-- 3. Document all database credentials securely
-- 4. Monitor backup job status
-- 5. Set up alerts for backup failures
-- 6. Use geo-replication for mission-critical databases
-- 7. Encrypt backups (automatic in Azure SQL)

-- ==========================================
-- QUICK REFERENCE
-- ==========================================

-- Check database size
SELECT 
    SUM(reserved_page_count) * 8.0 / 1024 / 1024 AS DatabaseSizeGB
FROM sys.dm_db_partition_stats;

-- Check table sizes
SELECT 
    t.NAME AS TableName,
    SUM(p.rows) AS RowCounts,
    SUM(a.total_pages) * 8 / 1024 AS TotalSpaceMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0
GROUP BY t.Name
ORDER BY TotalSpaceMB DESC;

-- Count records in each table
SELECT 'users' as TableName, COUNT(*) as RecordCount FROM users
UNION ALL
SELECT 'resources', COUNT(*) FROM resources
UNION ALL
SELECT 'theme_config', COUNT(*) FROM theme_config;
