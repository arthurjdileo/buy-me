CREATE TABLE SubCategory(
	id int NOT NULL AUTO_INCREMENT,
	cat_id int NOT NULL,
	name varchar(75) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (cat_id) REFERENCES Category(id)
);
