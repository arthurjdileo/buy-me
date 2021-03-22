package me.arthurdileo;

import java.sql.*;

/*
 * id
 * buyer_uuid
 * seller_uuid
 * listing_uuid
 * amount
 * created
 */

public class Bid {
	public String bid_uuid;
	public String buyer_uuid;
	public String listing_uuid;
	public double amount;
	public java.sql.Timestamp created;
	
	public Bid(String bid_uuid, String buyer_uuid, String listing_uuid, double amount) {
		this.bid_uuid = bid_uuid;
		this.buyer_uuid = buyer_uuid;
		this.listing_uuid = listing_uuid;
		this.amount = amount;
	}
	
	public Bid(ResultSet rs) throws SQLException {
		this(rs.getString("bid_uuid"), rs.getString("buyer_uuid"), rs.getString("listing_uuid"), rs.getDouble("amount"));
		this.created = rs.getTimestamp("created");
	}
	
}