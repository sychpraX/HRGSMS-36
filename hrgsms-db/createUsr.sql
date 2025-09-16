-- Create the database 
CREATE DATABASE IF NOT EXISTS hrgsms_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- create the same user for both host patterns
CREATE USER IF NOT EXISTS 'hrgsms_usr'@'localhost' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'hrgsms_usr'@'127.0.0.1' IDENTIFIED BY '1234';

-- grant privileges on the DB
GRANT ALL PRIVILEGES ON hrgsms_db.* TO 'hrgsms_usr'@'localhost';
GRANT ALL PRIVILEGES ON hrgsms_db.* TO 'hrgsms_usr'@'127.0.0.1';

FLUSH PRIVILEGES;
