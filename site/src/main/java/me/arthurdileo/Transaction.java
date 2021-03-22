package me.arthurdileo;

import java.sql.*;

/*
 * id
 * buyer_uuid
 * seller_uuid
 * listing_uuid
 * created
 */

public class Transaction {
	public String buyer_uuid;
	public String seller_uuid;
	public String listing_uuid;
	public float amount;
	public java.sql.Timestamp created;
	
	public Transaction(String buyer_uuid, String seller_uuid, String listing_uuid, float amount) {
		this.buyer_uuid = buyer_uuid;
		this.seller_uuid = seller_uuid;
		this.listing_uuid = listing_uuid;
		this.amount = amount;
	}
	
	public Transaction(ResultSet rs) throws SQLException {
		this(rs.getString("buyer_uuid"), rs.getString("seller_uuid"), rs.getString("listing_uuid"), rs.getFloat("amount"));
		this.created = rs.getTimestamp("created");
	}
	
}