package me.arthurdileo;

import java.sql.*;

/*
 * id
 * listing_uuid
 * seller_uuid
 * cat_id
 * sub_id
 * item_name
 * description
 * image
 * created
 * updated
 * listing_days
 * currency
 * start_price
 * reserve_price
 * end_time
 * bid_increment
 * is_active
 */

public class Listing implements Comparable<Listing>{
	public String listing_uuid;
	public String seller_uuid;
	public int cat_id;
	public int sub_id;
	public String item_name;
	public String description;
	public String image;
	public java.sql.Timestamp created;
	public java.sql.Timestamp updated;
	public int listing_days;
	public String currency;
	public double start_price;
	public double reserve_price;
	public java.sql.Timestamp end_time;
	public double bid_increment;
	public int is_active;
	
	public Listing(String listing_uuid, String seller_uuid, int cat_id, int sub_id,
			String description, String item_name, String image, int listing_days,
			String currency, double start_price, double reserve_price,
            java.sql.Timestamp end_time, double bid_increment, int is_active) {
		this.listing_uuid = listing_uuid;
		this.seller_uuid = seller_uuid;
		this.cat_id = cat_id;
		this.sub_id = sub_id;
		this.item_name = item_name;
		this.description = description;
		this.image = image;
		this.listing_days = listing_days;
		this.currency = currency;
		this.start_price = start_price;
		this.reserve_price = reserve_price;
		this.end_time = end_time;
		this.bid_increment = bid_increment;
		this.is_active = is_active;
	}
	
	public Listing(ResultSet rs) throws SQLException {
		this(rs.getString("listing_uuid"), rs.getString("seller_uuid"), rs.getInt("cat_id"), 
				rs.getInt("sub_id"), rs.getString("description"), rs.getString("item_name"),
				rs.getString("image"), rs.getInt("listing_days"), rs.getString("currency"),
				rs.getFloat("start_price"), rs.getFloat("reserve_price"), rs.getTimestamp("end_time"), 
				rs.getFloat("bid_increment"), rs.getInt("is_active"));
		this.created = rs.getTimestamp("created");
		this.updated = rs.getTimestamp("updated");
	}
	
	public String toString(Listing l) {
		return l.item_name;
	}
	
	@Override
	public int compareTo(Listing l) {
		return this.created.compareTo(l.created);
	}
}