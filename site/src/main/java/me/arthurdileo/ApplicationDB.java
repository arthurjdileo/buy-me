package me.arthurdileo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import java.sql.*;

public class ApplicationDB {
	
	public ApplicationDB(){
		
	}

	public Connection getConnection(){
		
		//Create a connection string
		String connectionUrl = "jdbc:mysql://35.245.72.206:3306/buy_me";
		Connection connection = null;
		
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver").newInstance();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try {
			//Create a connection to your DB
			connection = DriverManager.getConnection(connectionUrl,"webapp", "webapp");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return connection;
		
	}
	
	public void closeConnection(Connection connection){
		try {
			connection.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	public static void main(String[] args) {
		ApplicationDB dao = new ApplicationDB();
		Connection connection = dao.getConnection();
		System.out.println("----CONNECTION STARTED----");
		if (connection == null) {
			System.out.println("Connection is Null!");
		} else {
			System.out.println("NOT NULL");
			System.out.println(connection);
		}
		Statement st;
		try {
			st = connection.createStatement();
			ResultSet rs = st.executeQuery("select * from Users");
	        while(rs.next()){
	            System.out.println("UUID "+rs.getString(2));
	        }
		} catch (SQLException e) {
			System.out.println("Failed");
			e.printStackTrace();
		}
		dao.closeConnection(connection);
	}
	
	

}