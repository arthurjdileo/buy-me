CREATE TABLE Events(
	id int NOT NULL AUTO_INCREMENT,
	acc_uuid varchar(36) NOT NULL,
	modified datetime DEFAULT NOW() NOT NULL,
	msg varchar(75) NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(acc_uuid) REFERENCES Users(acc_uuid)
);
