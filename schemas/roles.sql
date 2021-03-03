CREATE TABLE Roles(
	id int NOT NULL AUTO_INCREMENT,
	created datetime DEFAULT NOW(),
	role varchar(30) NOT NULL UNIQUE,
	PRIMARY KEY (id)
)