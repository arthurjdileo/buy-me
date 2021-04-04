package me.arthurdileo;

import java.sql.*;

/*
 * id
 * acc_uuid
 * msg
 */

public class Event {
	public String acc_uuid;
	public String msg;
	public Timestamp modified;
	
	public Event(String acc_uuid, String msg) {
		this.acc_uuid = acc_uuid;
		this.msg = msg;
	}
	
	public Event(ResultSet rs) throws SQLException {
		this(rs.getString("acc_uuid"), rs.getString("msg"));
		this.modified = rs.getTimestamp("modified");
	}
	
}