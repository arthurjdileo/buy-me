CREATE TABLE AutomaticBid(
	id int NOT NULL AUTO_INCREMENT,
	buyer_uuid varchar(36) NOT NULL UNIQUE,
	listing_uuid varchar(36) NOT NULL UNIQUE,
	upper_limit decimal NOT NULL,
	increment decimal NOT NULL,
	created datetime DEFAULT NOW() NOT NULL,
	deleted datetime DEFAULT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(buyer_uuid) REFERENCES Users(acc_uuid),
	FOREIGN KEY(listing_uuid) REFERENCES Listing(listing_uuid)
);