package me.arthurdileo;

import java.sql.*;

/*
 * id
 * question_uuid
 * client_uuid
 * admin_uuid
 * created
 * updated
 * question
 * answer
 */

public class Question {
	public String question_uuid;
	public String client_uuid;
	public String admin_uuid;
	public String question;
	public String answer;
	public java.sql.Timestamp created;
	public java.sql.Timestamp updated;
	
	public Question(String question_uuid, String client_uuid, String question) {
		this.question_uuid = question_uuid;
		this.client_uuid = client_uuid;
		this.question = question;
	}
	
	public Question(ResultSet rs) throws SQLException {
		this(rs.getString("question_uuid"), rs.getString("client_uuid"), rs.getString("question"));
		this.admin_uuid = rs.getString("admin_uuid");
		this.answer = rs.getString("answer");
		this.created = rs.getTimestamp("created");
		this.updated = rs.getTimestamp("updated");
	}
	
}