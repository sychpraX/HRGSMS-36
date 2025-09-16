USE hrgsms_db;

CREATE TABLE IF NOT EXISTS Branch (
	branchID BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    location VARCHAR(20) NOT NULL,
	rating NUMERIC(2,1),
    phone char(12) NOT NULL,
    email varchar(30) NOT NULL,
    CONSTRAINT chk_phone CHECK(
		phone like "+94%"),
	CONSTRAINT chk_rating CHECK(
		rating >=0 AND rating <= 5)
	)
    