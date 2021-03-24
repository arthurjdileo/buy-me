package me.arthurdileo;

import java.sql.*;

/*
 * id
 * alert_uuid
 * acc_uuid
 * created
 * msg
 * ack
 */

public class Alert {
	public String alert_uuid;
	public String acc_uuid;
	public java.sql.Timestamp created;
	public String msg;
	public int ack;
	
	public Alert(String alert_uuid, String acc_uuid, String msg) {
		this.alert_uuid = alert_uuid;
		this.acc_uuid = acc_uuid;
		this.msg = msg;
	}
	
	public Alert(ResultSet rs) throws SQLException {
		this(rs.getString("alert_uuid"), rs.getString("acc_uuid"), rs.getString("msg"));
		this.created = rs.getTimestamp("created");
		this.ack = rs.getInt("ack");
	}
}