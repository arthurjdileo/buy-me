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
	public Time created;
	public Time updated;
	public String lastIP;
	public int pwReset;
	public int isActive;
	
	public User(String email, String password, String account_uuid,
			String firstName, String lastName,
			String lastIP, int pwReset, int isActive) {
		this.email = email;
		this.password = password;
		this.account_uuid = account_uuid;
		this.firstName = firstName;
		this.lastName = lastName;
		this.lastIP = lastIP;
		this.pwReset = pwReset;
		this.isActive = isActive;
	}
	
	public User(ResultSet rs) throws SQLException {
		this(rs.getString("email"), rs.getString("pw"),rs.getString("acc_uuid"), rs.getString("f_name"),
				rs.getString("l_name"), rs.getString("lastIP"), rs.getInt("pw_reset"),
				rs.getInt("is_active"));
		this.created = rs.getTime("created");
		this.updated = rs.getTime("updated");
	}
	
	public String toString() {
		return this.firstName + " " + this.lastName;
	}
}