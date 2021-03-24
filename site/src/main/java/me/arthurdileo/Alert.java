package me.arthurdileo;

import java.sql.*;

/*
 * id
 * acc_uuid
 * created
 * msg
 * ack
 */

public class Alert {
	public String acc_uuid;
	public java.sql.Timestamp created;
	public String msg;
	public int ack;
	
	public Alert(String acc_uuid, String msg, int ack) {
		this.acc_uuid = acc_uuid;
		this.msg = msg;
		this.ack = ack;
	}
	
	public Alert(ResultSet rs) throws SQLException {
		this(rs.getString("acc_uuid"), rs.getString("msg"), rs.getInt("ack"));
		this.created = rs.getTimestamp("created");
	}
}