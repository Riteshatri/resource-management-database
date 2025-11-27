-- ==========================================
-- CREATE DEFAULT ADMIN USER
-- ==========================================
-- IMPORTANT: Run this to create the first admin user
-- CHANGE ACCORDINGLY: Update email and password hash

-- ==========================================
-- SECURITY WARNING
-- ==========================================
-- The password below is 'Admin@123' (hashed with bcrypt)
-- CHANGE ACCORDINGLY: After first login, change this password immediately!
-- Or better, update the password here before running this script

-- To generate a new bcrypt hash for a different password:
-- Use Python: 
-- from passlib.context import CryptContext
-- pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
-- print(pwd_context.hash("YourNewPassword"))

-- ==========================================
-- INSERT ADMIN USER
-- ==========================================

-- CHANGE ACCORDINGLY: Update email, full_name, and password
INSERT INTO users (email, full_name, hashed_password, role, is_protected)
VALUES (
    'admin@example.com',  -- CHANGE ACCORDINGLY: Your admin email
    'System Administrator',  -- CHANGE ACCORDINGLY: Admin name
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5eU7L/vK5uiKW',  -- CHANGE ACCORDINGLY: Password hash for 'Admin@123'
    'admin',  -- Role: admin (DO NOT CHANGE)
    1  -- Protected: Yes (prevents deletion via UI)
);

-- Verify admin user was created
SELECT 
    id,
    email,
    full_name,
    role,
    is_protected,
    created_at
FROM users
WHERE role = 'admin';

-- ==========================================
-- NOTES
-- ==========================================
-- Default credentials (CHANGE IMMEDIATELY):
-- Email: admin@example.com
-- Password: Admin@123
--
-- To change password after first login:
-- 1. Login with default credentials
-- 2. Go to Profile page
-- 3. Update password
--
-- Or update in database directly with new hash
-- ==========================================
