package me.arthurdileo;

import java.sql.*;

/*
 * id
 * listing_uuid
 * bidder_uuid
 * seller_uuid
 * item_name
 * description
 * image
 * created
 * updated
 * listing_days
 * currency
 * start_price
 * reserve_price
 * num_bids
 * end_time
 * bid_increment
 * is_active
 */

public class Listing {
	public String listing_uuid;
	public String bidder_uuid;
	public String seller_uuid;
	public String item_name;
	public String description;
	public String image;
	public Time created;
	public Time updated;
	public int listing_days;
	public String currency;
	public float start_price;
	public float reserve_price;
	public int num_bids;
	public Time end_time;
	public float bid_increment;
	public int is_active;
	
	public Listing(String listing_uuid, String bidder_uuid, String seller_uuid,
			String description, String item_name, String image, int listing_days,
			String currency, float start_price, float reserve_price,
			int num_bids, Time end_time, float bid_increment, int is_active) {
		this.listing_uuid = listing_uuid;
		this.bidder_uuid = bidder_uuid;
		this.seller_uuid = seller_uuid;
		this.item_name = item_name;
		this.description = description;
		this.image = image;
		this.listing_days = listing_days;
		this.currency = currency;
		this.start_price = start_price;
		this.reserve_price = reserve_price;
		this.num_bids = num_bids;
		this.end_time = end_time;
		this.bid_increment = bid_increment;
		this.is_active = is_active;
	}
	
	public Listing(ResultSet rs) throws SQLException {
		this(rs.getString("listing_uuid"), rs.getString("bidder_uuid"), rs.getString("seller_uuid"),
				rs.getString("description"), rs.getString("item_name"), rs.getString("image"), rs.getInt("listing_days"), 
				rs.getString("currency"), rs.getFloat("start_price"), rs.getFloat("reserve_price"),
				rs.getInt("num_bids"), rs.getTime("end_time"), rs.getFloat("bid_increment"), rs.getInt("is_active"));
		this.created = rs.getTime("created");
		this.updated = rs.getTime("updated");
	}
	
	public String toString(Listing l) {
		return l.item_name;
	}
	
}