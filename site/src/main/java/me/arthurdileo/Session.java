package me.arthurdileo;

import java.sql.*;

/*
 * id
 * session_uuid
 * acc_uuid
 * created
*/

public class Session {
	public String session_uuid;
	public String acc_uuid;
	public java.sql.Timestamp created;
	
	public Session(String session_uuid, String acc_uuid) {
		this.session_uuid = session_uuid;
		this.acc_uuid = acc_uuid;
	}
	
	public Session(ResultSet rs) throws SQLException {
		this(rs.getString("session_uuid"), rs.getString("acc_uuid"));
		this.created = rs.getTimestamp("created");
	}
}