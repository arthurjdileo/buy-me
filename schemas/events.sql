CREATE TABLE Events(
  id int AUTO_INCREMENT,
  acc_uuid varchar(36),
  modified datetime,
  msg varchar(75),
  PRIMARY KEY(id),
  FOREIGN KEY(acc_uuid) REFERENCES Users
);