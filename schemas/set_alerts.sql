CREATE TABLE SetAlerts(
	id int NOT NULL AUTO_INCREMENT,
	alert_uuid varchar(36) UNIQUE NOT NULL,
	acc_uuid varchar(36) NOT NULL,
	created datetime DEFAULT NOW() NOT NULL,
	alert_type varchar(15) NOT NULL,
	alert varchar(350) NOT NULL,
	is_active int DEFAULT 1 NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(acc_uuid) REFERENCES Users(acc_uuid)
);
