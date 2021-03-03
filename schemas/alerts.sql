CREATE TABLE Alerts(
  id int AUTO_INCREMENT,
  acc_uuid varchar(36),
  created datetime,
  alert_time datetime,
  msg varchar(350),
  ack int,
  PRIMARY KEY(id),
  FOREIGN KEY(acc_uuid) REFERENCES Users
)