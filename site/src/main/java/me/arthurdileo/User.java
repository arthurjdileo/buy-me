package me.arthurdileo;

import java.sql.*;

/*
 * id
 * acc_uuid
 * created
 * updated
 * email
 * pw
 * f_name
 * l_name
 * lastIP
 * pw_reset
 * is_active
 */

public class User {
	public String email;
	public String password;
	public String account_uuid;
	public String firstName;
	public String lastName;
	public float credits;
	public java.sql.Timestamp created;
	public java.sql.Timestamp updated;
	public String lastIP;
	public int pwReset;
	public int isActive;
	
	public User(String email, String password, String account_uuid,
			String firstName, String lastName, float credits,
			String lastIP, int pwReset, int isActive) {
		this.email = email;
		this.password = password;
		this.account_uuid = account_uuid;
		this.firstName = firstName;
		this.lastName = lastName;
		this.credits = credits;
		this.lastIP = lastIP;
		this.pwReset = pwReset;
		this.isActive = isActive;
	}
	
	public User(ResultSet rs) throws SQLException {
		this(rs.getString("email"), rs.getString("pw"),rs.getString("acc_uuid"), rs.getString("f_name"),
				rs.getString("l_name"), rs.getFloat("credits"), rs.getString("lastIP"), rs.getInt("pw_reset"),
				rs.getInt("is_active"));
		this.created = rs.getTimestamp("created");
		this.updated = rs.getTimestamp("updated");
	}
	
	public String toString() {
		return this.firstName + " " + this.lastName;
	}
}