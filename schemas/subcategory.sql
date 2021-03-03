CREATE TABLE SubCategory(
	id int AUTO_INCREMENT,
	cat_id int,
	name varchar(75),
	PRIMARY KEY (id),
	FOREIGN KEY (cat_id) REFERENCES Category(id)
);