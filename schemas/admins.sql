CREATE TABLE Admins(
	id int NOT NULL AUTO_INCREMENT,
	acc_uuid varchar(36) NOT NULL UNIQUE,
	role varchar(30) NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(acc_uuid) REFERENCES Users(acc_uuid),
	FOREIGN KEY(role) REFERENCES Roles(role)
);