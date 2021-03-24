package me.arthurdileo;

import java.sql.*;

/*
 * id
 * acc_uuid
 * created
 * sub_cat_id
 * msg
 * ack
 */

public class Alert {
	public String acc_uuid;
	public java.sql.Timestamp created;
	public int sub_cat_id;
	public String msg;
	public int ack;
	
	public Alert(String acc_uuid, int sub_cat_id, String msg, int ack) {
		this.acc_uuid = acc_uuid;
		this.sub_cat_id = sub_cat_id;
		this.msg = msg;
		this.ack = ack;
	}
	
	public Alert(ResultSet rs) throws SQLException {
		this(rs.getString("acc_uuid"), rs.getInt("sub_cat_id"), rs.getString("msg"), rs.getInt("ack"));
		this.created = rs.getTimestamp("created");
	}
}