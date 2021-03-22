package me.arthurdileo;

import java.sql.*;

/*
 * id
 * cat_id
 * name
 */

public class SubCategory {
	public int id;
	public String name;
	public int cat_id;
	
	public SubCategory(int id, String name, int cat_id) {
		this.id = id;
		this.name = name;
		this.cat_id = cat_id;
	}
	
	public SubCategory(ResultSet rs) throws SQLException {
		this(rs.getInt("id"), rs.getString("name"), rs.getInt("cat_id"));
	}
}