CREATE TABLE Product(
	id int AUTO_INCREMENT,
	p_name varchar(75),
	category_id int,
	PRIMARY KEY (id),
	FOREIGN KEY (category_id) REFERENCES Category(id)
);