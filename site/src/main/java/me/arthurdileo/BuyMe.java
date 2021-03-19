package me.arthurdileo;

import java.util.*;
import java.sql.*;

public class BuyMe {
	
	public static ApplicationDB db;
	public static Connection conn;
	
	// loads database
	public static void loadDatabase() {
		if (db == null) {
			db = new ApplicationDB();
			conn = db.getConnection();
		}
	}
	
	public static class Users {
		static HashMap<String, User> UserTable;
		
		// get a specific user
		public static User get(String email) throws SQLException {
			return getAll().get(email);
		}
		
		// get list of users
		public static ArrayList<User> getAsList() throws SQLException {
			return new ArrayList<User>(getAll().values());
		}
		
		// gets user data from db
		static HashMap<String, User> getAll() throws SQLException {
			loadDatabase();
			if (UserTable == null) {
				UserTable = new HashMap<String, User>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("SELECT * from Users");
				
				while (rs.next()) {
					User u = new User(rs);
					UserTable.put(u.account_uuid, u);
				}
			}
			return UserTable;
		}
		
		public static void insert(User u) throws SQLException {
			String query = "INSERT INTO Users(acc_uuid, email, pw, f_name, l_name, lastIP) VALUES (?, ?, ?, ?, ?, ?);";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setObject(1, u.account_uuid);
			ps.setString(2, u.email);
			ps.setString(3, u.firstName);
			ps.setString(4, u.lastName);
			ps.setString(5, u.lastIP);
			ps.executeUpdate();
			UserTable = null;
			
		}
	}
	
	public static class Sessions {
		static HashMap<String, Session> SessionTable;
		
		public static Session get(String acc_uuid) throws SQLException {
			return getAll().get(acc_uuid);
		}
		
		public static ArrayList<Session> getAsList() throws SQLException {
			return new ArrayList<Session>(getAll().values());
		}
		
		static HashMap<String, Session> getAll() throws SQLException {
			loadDatabase();
			if (SessionTable == null) {
				SessionTable = new HashMap<String, Session>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from Sessions");
				while (rs.next()) {
					Session s = new Session(rs);
					SessionTable.put(s.acc_uuid, s);
				}
			}
			return SessionTable;
		}
		
		public static void insert(Session s) throws SQLException {
			String query = "INSERT INTO Sessions(session_uuid, acc_uuid) VALUES (?,?) ON DUPLICATE KEY UPDATE session_uuid = ?;";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, s.session_uuid);
			ps.setString(2, s.acc_uuid);
			ps.setString(3, s.session_uuid);
			ps.executeUpdate();
			SessionTable = null;
		}
		
		public static boolean validateSession(String session_uuid) throws SQLException {
			for (Session s : getAsList()) {
				if (s.session_uuid.equals(session_uuid)) {
					return true;
				}
			}
			return false;
		}
	}
}