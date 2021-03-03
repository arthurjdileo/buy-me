CREATE TABLE AutomaticBid(
  id int AUTO_INCREMENT,
  buyer_uuid varchar(36),
  listing_uuid varchar(36),
  upper_limit float,
  increment float,
  created datetime,
  deleted datetime,
  PRIMARY KEY(id),
  FOREIGN KEY(buyer_uuid) REFERENCES Users,
  FOREIGN KEY(listing_uuid) REFERENCES Listing
);