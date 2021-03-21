package me.arthurdileo;

import java.sql.*;

/*
 * id
 * acc_uuid
 * role
 */

public class Admin {
	public String acc_uuid;
	public String role;
	
	public Admin(String acc_uuid, String role) {
		this.acc_uuid = acc_uuid;
		this.role = role;
	}
	
	public Admin(ResultSet rs) throws SQLException {
		this(rs.getString("acc_uuid"), rs.getString("role"));
	}
}