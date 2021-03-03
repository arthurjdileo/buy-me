CREATE TABLE Users(
	id int NOT NULL AUTO_INCREMENT,
	acc_uuid varchar(36) NOT NULL UNIQUE,
	created datetime DEFAULT NOW() NOT NULL,
	updated datetime DEFAULT NOW() NOT NULL, 
	email varchar(100) NOT NULL,
	pw varchar(250) NOT NULL,
	f_name varchar(75) NOT NULL,
	l_name varchar(75) NOT NULL,
	lastIP varchar(20) NOT NULL,
	pw_reset int DEFAULT 0 NOT NULL,
	is_active int DEFAULT 1 NOT NULL,
	PRIMARY KEY (id)
);