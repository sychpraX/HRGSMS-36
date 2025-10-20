-- Seed users using DB stored procedure so the database salts/hashes passwords consistently
-- This is compatible with sp_login which uses fn_password_hash(salt, plain)

-- Remove test users if they exist (idempotent)
DELETE FROM User_Account WHERE username IN ('alice.admin','bob.manager','carol.recep','dan.staff','eve.staff');

-- Create users via stored procedure (sp_create_user expects plaintext password)
CALL sp_create_user('alice.admin', 'AdminPass!2025', 'Admin');
CALL sp_create_user('bob.manager', 'Manager#2025', 'Manager');
CALL sp_create_user('carol.recep', 'Recep$2025', 'Reception');
CALL sp_create_user('dan.staff', 'Staff*2025', 'Staff');
CALL sp_create_user('eve.staff', 'Staff2@2025', 'Staff');

-- Verify: select inserted rows
SELECT userID, username, userRole, branchID FROM User_Account WHERE username IN ('alice.admin','bob.manager','carol.recep','dan.staff','eve.staff');
