CREATE TABLE Permissions(
	id int NOT NULL AUTO_INCREMENT,
	role varchar(30) NOT NULL,
	permission varchar(30) NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (role) REFERENCES Roles(role)
);