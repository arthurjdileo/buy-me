CREATE TABLE Questions(
	id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	question_uuid varchar(36) NOT NULL UNIQUE,
	client_uuid varchar(36) NOT NULL,
	admin_uuid varchar(36) DEFAULT NULL,
	created datetime DEFAULT NOW() NOT NULL,
	updated datetime DEFAULT NOW() ON UPDATE NOW() NOT NULL,
	question varchar(350) NOT NULL,
	answer varchar(350) DEFAULT NULL,
	rejected datetime DEFAULT NULL,
)
