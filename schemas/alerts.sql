CREATE TABLE Alerts(
	id int NOT NULL AUTO_INCREMENT,
	set_alert_uuid varchar(36) NOT NULL,
	alert_uuid varchar(36) NOT NULL,
	created datetime DEFAULT NOW() NOT NULL,
	msg varchar(200) NOT NULL,
	ack int DEFAULT 0 NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (set_alert_uuid) REFERENCES SetAlerts(alert_uuid) 
);
