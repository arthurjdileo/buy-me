package me.arthurdileo;

import java.sql.*;

/*
 * id
 * alert_uuid
 * acc_uuid
 * created
 * alert_type (item, category, subcategory)
 * alert (criteria)
 * is_active
 */

public class SetAlert {
	public String alert_uuid;
	public String acc_uuid;
	public java.sql.Timestamp created;
	public String alert_type;
	public String alert;
	public int is_active;
	
	public SetAlert(String alert_uuid, String acc_uuid, String alert_type, String alert) {
		this.alert_uuid = alert_uuid;
		this.acc_uuid = acc_uuid;
		this.alert_type = alert_type;
		this.alert = alert;
	}
	
	public SetAlert(ResultSet rs) throws SQLException {
		this(rs.getString("alert_uuid"), rs.getString("acc_uuid"), rs.getString("alert_type"), rs.getString("alert"));
		this.created = rs.getTimestamp("created");
		this.is_active = rs.getInt("is_active");
	}
}