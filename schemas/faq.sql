CREATE TABLE FAQ(
	id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	question_uuid varchar(36) NOT NULL UNIQUE,
	admin_uuid varchar(36) NOT NULL UNIQUE,
	created datetime DEFAULT NOW() NOT NULL,
	updated datetime DEFAULT NOW() ON UPDATE NOW() NOT NULL,
	question varchar(350) NOT NULL,
	answer varchar(350) NOT NULL
)
