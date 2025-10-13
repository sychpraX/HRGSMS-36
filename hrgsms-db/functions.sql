DELIMITER $$
--Used to hash the password(SHAR 2 protocol is used)
DROP FUNCTION IF EXISTS fn_password_hash $$
CREATE FUNCTION fn_password_hash(p_salt VARBINARY(16), p_plain VARCHAR(255))
    RETURNS VARBINARY(32)
    DETERMINISTIC
    RETURN UNHEX(SHA2(CONCAT(HEX(p_salt), p_plain), 256)) $$


-- Used to check the role of the user
DROP FUNCTION IF EXISTS fn_has_role $$
CREATE FUNCTION fn_has_role(p_userID BIGINT UNSIGNED, p_role VARCHAR(20))
RETURNS TINYINT(1)
DETERMINISTIC
RETURN EXISTS (
  SELECT 1 FROM User_Account WHERE userID = p_userID AND userRole = p_role
) $$