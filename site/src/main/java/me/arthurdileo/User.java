package me.arthurdileo;

import java.sql.*;
import java.time.*;
import java.util.UUID;

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
			String firstName, String lastName, Time created, Time updated,
			String lastIP, int pwReset, int isActive) {
		this.email = email;
		this.password = password;
		this.account_uuid = account_uuid;
		this.firstName = firstName;
		this.lastName = lastName;
		this.created = created;
		this.updated = updated;
		this.lastIP = lastIP;
		this.pwReset = pwReset;
		this.isActive = isActive;
	}
	
	public User(ResultSet rs) throws SQLException {
		this(rs.getString("email"), rs.getString("pw"),rs.getString("acc_uuid"), rs.getString("f_name"),
				rs.getString("l_name"), rs.getTime("created"), rs.getTime("updated"),
				rs.getString("lastIP"), rs.getInt("pw_reset"), rs.getInt("is_active"));
	}
	
	public String toString() {
		return this.firstName + " " + this.lastName;
	}
}