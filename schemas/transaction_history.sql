CREATE TABLE TransactionHistory(
	id int NOT NULL AUTO_INCREMENT,
	buyer_uuid varchar(36) NOT NULL UNIQUE,
	seller_uuid varchar(36) NOT NULL UNIQUE,
	listing_uuid varchar(36) NOT NULL UNIQUE,
	amount decimal(10, 2) NOT NULL,
	created datetime DEFAULT NOW() NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (buyer_uuid) REFERENCES Users(acc_uuid),
	FOREIGN KEY (seller_uuid) REFERENCES Users(acc_uuid),
	FOREIGN KEY (listing_uuid) REFERENCES Listing(listing_uuid)
);
