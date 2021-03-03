CREATE TABLE Sessions(
  id int AUTO_INCREMENT,
  session_uuid varchar(36),
  acc_uuid varchar(36),
  created datetime,
  PRIMARY KEY(id),
  FOREIGN KEY(acc_uuid) REFERENCES Users
);