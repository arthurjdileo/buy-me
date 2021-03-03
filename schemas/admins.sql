CREATE TABLE Admins(
  id int AUTO_INCREMENT,
  acc_uuid varchar(36),
  role varchar(30),
  PRIMARY KEY(id),
  FOREIGN KEY(acc_uuid) REFERENCES Users
);