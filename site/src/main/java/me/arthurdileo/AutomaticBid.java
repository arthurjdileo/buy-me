package me.arthurdileo;

import java.sql.*;

/*
 * id
 * buyer_uuid
 * listing_uuid
 * upper_limit
 * increment
 * created
 * deleted
 */

public class AutomaticBid {
	public String buyer_uuid;
	public String listing_uuid;
	public double upper_limit;
	public double increment;
	public java.sql.Timestamp created;
	public java.sql.Timestamp deleted;
	
	public AutomaticBid(String buyer_uuid, String listing_uuid, double upper_limit, double increment) {
		this.buyer_uuid = buyer_uuid;
		this.listing_uuid = listing_uuid;
		this.upper_limit = upper_limit;
		this.increment = increment;
	}
	
	public AutomaticBid(ResultSet rs) throws SQLException {
		this(rs.getString("buyer_uuid"), rs.getString("listing_uuid"), rs.getDouble("upper_limit"), rs.getDouble("increment"));
		this.created = rs.getTimestamp("created");
		this.deleted = rs.getTimestamp("deleted");
	}
	
}