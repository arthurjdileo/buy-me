CREATE TABLE Permissions(
  id int AUTO_INCREMENT,
  role varchar(30),
  permission varchar(30),
  PRIMARY KEY(id),
  FOREIGN KEY(role) REFERENCES Admins
);