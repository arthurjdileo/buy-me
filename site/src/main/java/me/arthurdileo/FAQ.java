package me.arthurdileo;

import java.sql.*;

/*
 * id
 * question_uuid
 * admin_uuid
 * created
 * updated
 * question
 * answer
 */

public class FAQ {
	public String question_uuid;
	public String admin_uuid;
	public String question;
	public String answer;
	public Time created;
	public Time updated;
	
	public FAQ(String question_uuid, String admin_uuid, String question, String answer) {
		this.question_uuid = question_uuid;
		this.admin_uuid = admin_uuid;
		this.question = question;
		this.answer = answer;
	}
	
	public FAQ(ResultSet rs) throws SQLException {
		this(rs.getString("question_uuid"), rs.getString("admin_uuid"), rs.getString("question"),
				rs.getString("answer"));
		this.created = rs.getTime("created");
		this.updated = rs.getTime("updated");
	}
	
}