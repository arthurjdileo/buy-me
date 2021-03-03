CREATE TABLE Users(
	id int AUTO_INCREMENT,
	acc_uuid varchar(36),
	created datetime,
	updated datetime, 
	email varchar(100),
	pw varchar(250),
	f_name varchar(75),
	l_name varchar(75),
	lastIP varchar(20),
	pw_reset int,
	is_active int,
	PRIMARY KEY (id)
);