CREATE TABLE Alerts(
	id int NOT NULL AUTO_INCREMENT,
	acc_uuid varchar(36) NOT NULL UNIQUE,
	created datetime DEFAULT NOW() NOT NULL,
	sub_cat_id int NOT NULL,
	msg varchar(350) NOT NULL,
	ack int NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(acc_uuid) REFERENCES Users(acc_uuid),
	FOREIGN KEY(sub_cat_id) REFERENCES SubCategory(cat_id)
);