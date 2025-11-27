-- ==========================================
-- RESOURCE MANAGEMENT DASHBOARD
-- Database Schema Creation Script
-- ==========================================
-- Run this script in Azure SQL Database Query Editor
-- This creates all required tables for the application

-- ==========================================
-- USERS TABLE
-- ==========================================
-- Stores user accounts with authentication and profile info

CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255) NOT NULL UNIQUE,
    full_name NVARCHAR(255),
    hashed_password NVARCHAR(255) NOT NULL,
    role NVARCHAR(50) NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'user')),
    is_protected BIT DEFAULT 0,  -- Protected users cannot be deleted/modified
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);

-- Index for faster email lookups
CREATE INDEX IX_users_email ON users(email);
CREATE INDEX IX_users_role ON users(role);

-- ==========================================
-- RESOURCES TABLE
-- ==========================================
-- Stores infrastructure resources (VMs, databases, etc.)

CREATE TABLE resources (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    type NVARCHAR(100),  -- e.g., 'Virtual Machine', 'Database', 'Storage'
    status NVARCHAR(50) DEFAULT 'active',  -- 'active', 'inactive', 'pending'
    region NVARCHAR(100),  -- e.g., 'Southeast Asia', 'East US'
    cpu_usage FLOAT DEFAULT 0,  -- Percentage (0-100)
    memory_usage FLOAT DEFAULT 0,  -- Percentage (0-100)
    storage_usage FLOAT DEFAULT 0,  -- Percentage (0-100)
    network_usage FLOAT DEFAULT 0,  -- Percentage (0-100)
    description NVARCHAR(MAX),
    user_id INT NOT NULL,  -- Owner of the resource
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign key to users table
    CONSTRAINT FK_resources_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Indexes for faster queries
CREATE INDEX IX_resources_user_id ON resources(user_id);
CREATE INDEX IX_resources_status ON resources(status);
CREATE INDEX IX_resources_type ON resources(type);

-- ==========================================
-- THEME CONFIG TABLE
-- ==========================================
-- Stores user-specific theme preferences

CREATE TABLE theme_config (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,  -- One theme config per user
    color_scheme NVARCHAR(50) DEFAULT 'blue',  -- 'blue', 'green', 'purple', 'orange', 'pink'
    dark_mode BIT DEFAULT 0,  -- 0 = light mode, 1 = dark mode
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign key to users table
    CONSTRAINT FK_theme_config_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Index for faster user theme lookups
CREATE INDEX IX_theme_config_user_id ON theme_config(user_id);

-- ==========================================
-- AUTO-UPDATE TRIGGERS
-- ==========================================
-- Automatically update 'updated_at' timestamp on record updates

GO

-- Trigger for users table
CREATE TRIGGER trg_users_updated_at
ON users
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE users
    SET updated_at = GETDATE()
    FROM users u
    INNER JOIN inserted i ON u.id = i.id;
END;

GO

-- Trigger for resources table
CREATE TRIGGER trg_resources_updated_at
ON resources
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE resources
    SET updated_at = GETDATE()
    FROM resources r
    INNER JOIN inserted i ON r.id = i.id;
END;

GO

-- Trigger for theme_config table
CREATE TRIGGER trg_theme_config_updated_at
ON theme_config
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE theme_config
    SET updated_at = GETDATE()
    FROM theme_config tc
    INNER JOIN inserted i ON tc.id = i.id;
END;

GO

-- ==========================================
-- VERIFICATION
-- ==========================================
-- Check that all tables were created successfully

SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Expected output: users, resources, theme_config
