package me.arthurdileo;

import java.sql.*;

/*
 * id
 * name
 */

public class Category {
	public String name;
	
	public Category(String name) {
		this.name = name;
	}
	
	public Category(ResultSet rs) throws SQLException {
		this(rs.getString("name"));
	}
}