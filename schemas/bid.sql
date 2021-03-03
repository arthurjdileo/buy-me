CREATE TABLE Bid(
	id int AUTO_INCREMENT,
	buyer_uuid varchar(36),
	seller_uuid varchar(36),
	listing_uuid varchar(36),
	created datetime,
	PRIMARY KEY (id),
	FOREIGN KEY (buyer_uuid) REFERENCES Users(acc_uuid),
	FOREIGN KEY (seller_uuid) REFERENCES Users(acc_uuid),
	FOREIGN KEY (listing_uuid) REFERENCES Listing(listing_uuid)
)