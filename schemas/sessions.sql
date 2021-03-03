CREATE TABLE Sessions(
  id int NOT NULL AUTO_INCREMENT,
  session_uuid varchar(36) NOT NULL UNIQUE,
  acc_uuid varchar(36) NOT NULL UNIQUE,
  created datetime DEFAULT NOW() NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY(acc_uuid) REFERENCES Users(acc_uuid)
);