--Used to create the user with hashed password
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_create_user $$
CREATE PROCEDURE sp_create_user(
  IN p_username VARCHAR(50),
  IN p_plain VARCHAR(255),
  IN p_role VARCHAR(20)
)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists';
    END IF;

    IF p_role NOT IN ('Admin','Manager','Staff','Guest') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid role';
    END IF;

    SET @salt := RANDOM_BYTES(16);
    SET @hash := fn_password_hash(@salt, p_plain);

    INSERT INTO Users(username, password_hash, salt, userRole)
    VALUES (p_username, @hash, @salt, p_role);

    SELECT LAST_INSERT_ID() AS userID;
END $$

-- 2.3 Create user (DB does salt + hash)
DROP PROCEDURE IF EXISTS sp_create_user $$
CREATE PROCEDURE sp_create_user(
  IN p_username VARCHAR(50),
  IN p_plain VARCHAR(255),
  IN p_role VARCHAR(20)
)
BEGIN
  IF EXISTS (SELECT 1 FROM Users WHERE username = p_username) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists';
  END IF;

  IF p_role NOT IN ('Admin','Manager','Staff','Guest') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid role';
  END IF;

  SET @salt := RANDOM_BYTES(16);
  SET @hash := fn_password_hash(@salt, p_plain);

  INSERT INTO Users(username, password_hash, salt, userRole)
  VALUES (p_username, @hash, @salt, p_role);

  SELECT LAST_INSERT_ID() AS userID;
END $$

-- Used for login verification
DROP PROCEDURE IF EXISTS sp_login $$
CREATE PROCEDURE sp_login(
  IN p_username VARCHAR(50),
  IN p_plain VARCHAR(255)
)
BEGIN
  DECLARE v_userID BIGINT UNSIGNED;
  DECLARE v_role VARCHAR(20);
  DECLARE v_salt VARBINARY(16);
  DECLARE v_hash VARBINARY(32);

  SELECT userID, userRole, salt, password_hash
    INTO v_userID, v_role, v_salt, v_hash
  FROM Users
  WHERE username = p_username AND is_active = 1
  LIMIT 1;

  IF v_userID IS NULL THEN
    SELECT 0 AS success, NULL AS userID, NULL AS username, NULL AS userRole;
  ELSE
    IF fn_password_hash(v_salt, p_plain) = v_hash THEN
      SELECT 1 AS success, v_userID AS userID, p_username AS username, v_role AS userRole;
    ELSE
      SELECT 0 AS success, NULL AS userID, NULL AS username, NULL AS userRole;
    END IF;
  END IF;
END $$

