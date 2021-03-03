CREATE TABLE Product(
	id int NOT NULL AUTO_INCREMENT,
	p_name varchar(75) NOT NULL,
	category_id int NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (category_id) REFERENCES Category(id)
);