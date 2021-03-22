CREATE TABLE AutomaticBid(
	id int NOT NULL AUTO_INCREMENT,
	buyer_uuid varchar(36) NOT NULL,
	listing_uuid varchar(36) NOT NULL,
	upper_limit decimal(10,2) NOT NULL,
	increment decimal(10,2) NOT NULL,
	created datetime DEFAULT NOW() NOT NULL,
	deleted datetime DEFAULT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(buyer_uuid) REFERENCES Users(acc_uuid),
	FOREIGN KEY(listing_uuid) REFERENCES Listing(listing_uuid)
);
