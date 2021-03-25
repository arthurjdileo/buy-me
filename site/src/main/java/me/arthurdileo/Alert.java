package me.arthurdileo;

import java.sql.*;

/*
 * id
 * set_alert_uuid
 * alert_uuid
 * created
 * msg
 * ack
 */

public class Alert {
	public String set_alert_uuid;
	public String alert_uuid;
	public java.sql.Timestamp created;
	public String msg;
	public int ack;
	
	public Alert(String set_alert_uuid, String alert_uuid, String msg) {
		this.set_alert_uuid = set_alert_uuid;
		this.alert_uuid = alert_uuid;
		this.msg = msg;
	}
	
	public Alert(ResultSet rs) throws SQLException {
		this(rs.getString("set_alert_uuid"), rs.getString("alert_uuid"), rs.getString("msg"));
		this.created = rs.getTimestamp("created");
		this.ack = rs.getInt("ack");
	}
}