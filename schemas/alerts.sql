CREATE TABLE Alerts(
	id int NOT NULL AUTO_INCREMENT,
	alert_uuid varchar(36) NOT NULL,
	acc_uuid varchar(36) NOT NULL,
	created datetime DEFAULT NOW() NOT NULL,
	msg varchar(200) NOT NULL,
	ack int DEFAULT 0 NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(acc_uuid) REFERENCES Users(acc_uuid)
);
