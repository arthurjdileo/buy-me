package me.arthurdileo;

import java.sql.*;

/*
 * id
 * name
 */

public class Category {
	public int id;
	public String name;
	
	public Category(int id, String name) {
		this.id = id;
		this.name = name;
	}
	
	public Category(ResultSet rs) throws SQLException {
		this(rs.getInt("id"), rs.getString("name"));
	}
}