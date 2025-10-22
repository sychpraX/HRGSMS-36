-- Clear existing users
DELETE FROM User_Account;

-- Reset auto-increment
ALTER TABLE User_Account AUTO_INCREMENT = 1;

-- Insert test users with hashed passwords
CALL sp_create_user('admin', 'admin123', 'Admin');
CALL sp_create_user('manager', 'manager123', 'Manager');
CALL sp_create_user('reception', 'reception123', 'Reception');
CALL sp_create_user('staff', 'staff123', 'Staff');