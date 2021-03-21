package me.arthurdileo;

import java.util.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.*;
import java.io.IOException;
import java.math.BigInteger;  
import java.nio.charset.StandardCharsets; 
import java.security.MessageDigest;  
import java.security.NoSuchAlgorithmException;  

public class BuyMe {
	
	public static ApplicationDB db;
	public static Connection conn;
	
	// loads database
	public static void loadDatabase() {
		if (db == null || conn == null) {
			db = new ApplicationDB();
			conn = db.getConnection();
		}
	}
	
	public static String genUUID() {
		return UUID.randomUUID().toString();
	}
	
	// contains users hashmap
	public static class Users {
		static HashMap<String, User> UserTable;
		
		// get a specific user
		public static User get(String acc_uuid) throws SQLException {
			return getAll().get(acc_uuid);
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
		
		// insert a user object into db
		public static void insert(User u) throws SQLException {
			loadDatabase();
			String query = "INSERT INTO Users(acc_uuid, email, pw, f_name, l_name, lastIP) VALUES (?, ?, ?, ?, ?, ?);";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setObject(1, u.account_uuid);
			ps.setString(2, u.email);
			ps.setString(3, u.password);
			ps.setString(4, u.firstName);
			ps.setString(5, u.lastName);
			ps.setString(6, u.lastIP);
			ps.executeUpdate();
			UserTable = null;
		}
	}
	
	public static class Sessions {
		static HashMap<String, Session> SessionTable;
		
		// get session by acc uuid
		public static Session get(String acc_uuid) throws SQLException {
			return getAll().get(acc_uuid);
		}
		
		// get User by session uuid
		public static User getBySession(String session_uuid) throws SQLException {
			ArrayList<Session> sessions = getAsList();
			for (Session s : sessions) {
				if (s.session_uuid.equals(session_uuid)) {
					return Users.get(s.acc_uuid);
				}
			}
			return null;
		}
		
		// get session UUID of page
		public static String getCurrentSession(Cookie[] cookies) throws SQLException {
        	String sessionUUID = null;
        	if (cookies != null) {
        		for (Cookie cookie : cookies) {
        			if (cookie.getName().equals("SESSION_UUID")) {
        				sessionUUID = cookie.getValue();
        			}
        		}
        	}
        	return sessionUUID;
		}
		
		// sessions as list
		public static ArrayList<Session> getAsList() throws SQLException {
			return new ArrayList<Session>(getAll().values());
		}
		
		// updates table from db
		static HashMap<String, Session> getAll() throws SQLException {
			loadDatabase();
			if (SessionTable == null) {
				SessionTable = new HashMap<String, Session>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from Sessions;");
				while (rs.next()) {
					Session s = new Session(rs);
					SessionTable.put(s.acc_uuid, s);
				}
			}
			return SessionTable;
		}
		
		// insert session into db
		public static void insert(Session s) throws SQLException {
			loadDatabase();
			String query = "INSERT INTO Sessions(session_uuid, acc_uuid) VALUES (?,?) ON DUPLICATE KEY UPDATE session_uuid = ?;";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, s.session_uuid);
			ps.setString(2, s.acc_uuid);
			ps.setString(3, s.session_uuid);
			ps.executeUpdate();
			SessionTable = null;
		}
		
		// remove session from db
		public static void remove(String session_uuid) throws SQLException {
			String query = "DELETE FROM Sessions WHERE session_uuid = ?;";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, session_uuid);
			ps.executeUpdate();
			SessionTable = null;
		}
		
		// validate a session uuid
		public static boolean validateSession(String session_uuid) throws SQLException {
			for (Session s : getAsList()) {
				if (s.session_uuid.equals(session_uuid)) {
					return true;
				}
			}
			return false;
		}
		
		// if logged in: send to req page
		// else: redirect to login
		public static boolean safetyCheck(Cookie[] cookies) throws SQLException, IOException {
        	String sessionUUID = null;
        	if (cookies != null) {
        		for (Cookie cookie : cookies) {
        			if (cookie.getName().equals("SESSION_UUID")) {
        				sessionUUID = cookie.getValue();
        			}
        		}
        	}
        	if (cookies == null || sessionUUID == null || !validateSession(sessionUUID)) {
        		return false;
        	}
        	return true;
		}
		
		// hash String using SHA256
		public static String hashPassword(String password) throws NoSuchAlgorithmException{
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			
			byte[] bytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
			
			BigInteger n = new BigInteger(1, bytes);
			StringBuilder hexString = new StringBuilder(n.toString(16));
			
			while (hexString.length() < 32) {
				hexString.insert(0, '0');
			}
			return hexString.toString();
		}
	}
	
	public static class Listings {
		static HashMap<String, Listing> ListingsTable;
		
		// get listing by listing uuid
		public static Listing get(String listing_uuid) throws SQLException {
			return getAll().get(listing_uuid);
		}
		
		// listings as list
		public static ArrayList<Listing> getAsList() throws SQLException {
			return new ArrayList<Listing>(getAll().values());
		}
				
		// updates table from db
		static HashMap<String, Listing> getAll() throws SQLException {
			loadDatabase();
			if (ListingsTable == null) {
				ListingsTable = new HashMap<String, Listing>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from Listings;");
				while (rs.next()) {
					Listing l = new Listing(rs);
					ListingsTable.put(l.listing_uuid, l);
				}
			}
			return ListingsTable;
		}
		
		// insert listing into db
		public static void insert(Listing l) throws SQLException {
			loadDatabase();
			String query = "INSERT INTO Listing(listing_uuid, bidder_uuid, seller_uuid, item_name, description, image, listing_days, currency, start_price, reserve_price, num_bids, bid_increment) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, l.listing_uuid);
			ps.setString(2, l.bidder_uuid);
			ps.setString(3, l.seller_uuid);
			ps.setString(4, l.item_name);
			ps.setString(5, l.description);
			ps.setString(6, l.image);
			ps.setInt(7, l.listing_days);
			ps.setString(8, l.currency);
			ps.setFloat(9, l.start_price);
			ps.setFloat(10, l.reserve_price);
			ps.setInt(11, l.num_bids);
			ps.setFloat(12, l.bid_increment);
			ps.executeUpdate();
			ListingsTable = null;
		}
		
		// remove listing from db
		public static void remove(String listing_uuid) throws SQLException {
			loadDatabase();
			String query = "UPDATE Listings SET is_active = 0 WHERE listing_uuid = ?;";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, listing_uuid);
			ps.executeUpdate();
			ListingsTable = null;
		}
		
		public static ArrayList<Listing> searchByName(String query) throws SQLException {
			ArrayList<Listing> listings = getAsList();
			ArrayList<Listing> searchResults = new ArrayList<Listing>();
			String[] split = query.split(" ");
			
			for (Listing l : listings) {
				for (String s : split) {
					if (l.item_name.contains(s)) {
						searchResults.add(l);
					}
				}
			}
			return searchResults;
		}
		
//		public static User getWinner()
		
		// determine winner by reserve
		public static User getWinnerReserve(Listing l) throws SQLException {
			ArrayList<Bid> bids = Bids.getBidsByListing(l.listing_uuid);
			for (Bid b : bids) {
				if (b.amount >= l.reserve_price) {
					return Users.get(b.buyer_uuid);
				}
			}
			return null;
		}
	}
	
	public static class Bids {
		static HashMap<String, Bid> BidsTable;
		
		// get bids by listing
		public static Bid get(String listing_uuid) throws SQLException {
			return getAll().get(listing_uuid);
		}
		
		// bids as list
		public static ArrayList<Bid> getAsList() throws SQLException {
			return new ArrayList<Bid>(getAll().values());
		}
				
		// updates table from db
		static HashMap<String, Bid> getAll() throws SQLException {
			loadDatabase();
			if (BidsTable == null) {
				BidsTable = new HashMap<String, Bid>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from Bids;");
				while (rs.next()) {
					Bid b = new Bid(rs);
					BidsTable.put(b.listing_uuid, b);
				}
			}
			return BidsTable;
		}
		
		// create a new bid
		public static void insert(Bid b) throws SQLException {
			loadDatabase();
//			check for errors
			String query = "INSERT INTO Bids(buyer_uuid, seller_uuid, listing_uuid, amount) VALUES (?, ?, ?, ?);";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, b.buyer_uuid);
			ps.setString(2, b.seller_uuid);
			ps.setString(3, b.listing_uuid);
			ps.setFloat(4, b.amount);
			ps.executeUpdate();
			BidsTable = null;
			
			// winner checks
//			if (isWinner(b) != null) {
//				Listings.remove(b.listing_uuid);
//				Transaction t = new Transaction(b.buyer_uuid, b.seller_uuid, b.listing_uuid, b.amount);
//				TransactionHistory.insert(t);
//			}
		}
		
		// get all bids for listing
		public static ArrayList<Bid> getBidsByListing(String listing_uuid) throws SQLException {
			ArrayList<Bid> bids = getAsList();
			ArrayList<Bid> listingBids = new ArrayList<Bid>();
			
			for (Bid b : bids) {
				if (b.listing_uuid.equals(listing_uuid)) {
					listingBids.add(b);
				}
			}
			return listingBids;
		}
		
		// get bid by user
		public static ArrayList<Bid> getBidsByUser(String account_uuid) throws SQLException {
			ArrayList<Bid> bids = getAsList();
			ArrayList<Bid> userBids = new ArrayList<Bid>();
			
			for (Bid b : bids) {
				if (b.buyer_uuid.equals(account_uuid)) {
					userBids.add(b);
				}
			}
			return userBids;
		}
		
		// get top bid by listing
		public static Bid topBid(Listing l) throws SQLException {
			ArrayList<Bid> bids = Bids.getBidsByListing(l.listing_uuid);
			
			float maxBid = 0;
			Bid topBid = null;
			for (Bid b : bids) {
				if (b.amount > maxBid) {
					maxBid = b.amount;
					topBid = b;
				}
			}
			return topBid;
		}
	}
	
	public static class TransactionHistory {
		static HashMap<String, Transaction> TransactionsTable;
		
		// get transaction by listing
		public static Transaction get(String listing_uuid) throws SQLException {
			return getAll().get(listing_uuid);
		}
		
		// transactions as list
		public static ArrayList<Transaction> getAsList() throws SQLException {
			return new ArrayList<Transaction>(getAll().values());
		}
				
		// updates table from db
		static HashMap<String, Transaction> getAll() throws SQLException {
			loadDatabase();
			if (TransactionsTable == null) {
				TransactionsTable = new HashMap<String, Transaction>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from TransactionHistory;");
				while (rs.next()) {
					Transaction t = new Transaction(rs);
					TransactionsTable.put(t.listing_uuid, t);
				}
			}
			return TransactionsTable;
		}
		
		public static void insert(Transaction t) throws SQLException {
			loadDatabase();
			String query = "INSERT INTO TransactionHistory(buyer_uuid, seller_uuid, listing_uuid, amount) VALUES (?, ?, ?, ?);";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, t.buyer_uuid);
			ps.setString(2, t.seller_uuid);
			ps.setString(3, t.listing_uuid);
			ps.setFloat(4, t.amount);
			ps.executeUpdate();
			TransactionsTable = null;
		}
		
		public static ArrayList<Transaction> getByBuyer(String buyer_uuid) throws SQLException {
			ArrayList<Transaction> transactions = getAsList();
			ArrayList<Transaction> buyerTrans = new ArrayList<Transaction>();
			
			for (Transaction t : transactions) {
				if (t.buyer_uuid.equals(buyer_uuid)) {
					buyerTrans.add(t);
				}
			}
			return buyerTrans;
		}
		
		public static ArrayList<Transaction> getBySeller(String seller_uuid) throws SQLException {
			ArrayList<Transaction> transactions = getAsList();
			ArrayList<Transaction> sellerTrans = new ArrayList<Transaction>();
			
			for (Transaction t : transactions) {
				if (t.buyer_uuid.equals(seller_uuid)) {
					sellerTrans.add(t);
				}
			}
			return sellerTrans;
		}
	}
	
	public static class Questions {
		static HashMap<String, Question> QuestionsTable;
		
		// get question by user
		public static Question get(String account_uuid) throws SQLException {
			return getAll().get(account_uuid);
		}
		
		// transactions as list
		public static ArrayList<Question> getAsList() throws SQLException {
			return new ArrayList<Question>(getAll().values());
		}
				
		// updates table from db
		static HashMap<String, Question> getAll() throws SQLException {
			loadDatabase();
			if (QuestionsTable == null) {
				QuestionsTable = new HashMap<String, Question>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from Questions;");
				while (rs.next()) {
					Question q = new Question(rs);
					QuestionsTable.put(q.client_uuid, q);
				}
			}
			return QuestionsTable;
		}
		
		// create question
		public static void insert(Question q) throws SQLException {
			loadDatabase();
			String query = "INSERT INTO Questions(question_uuid, client_uuid, admin_uuid, question, answer) VALUES (?, ?, ?, ?, ?);";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, q.question_uuid);
			ps.setString(2, q.client_uuid);
			ps.setString(3, q.admin_uuid);
			ps.setString(4, q.question);
			ps.setString(5, q.answer);
			ps.executeUpdate();
			QuestionsTable = null;
		}
		
		// answer question
		public static void answer(Question q, String answer) throws SQLException {
			loadDatabase();
			String query = "UPDATE Questions SET answer = ? WHERE question_uuid = ?;";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, answer);
			ps.setString(2, q.question_uuid);
			ps.executeUpdate();
			QuestionsTable = null;
		}
	}
	
	public static class FAQs {
		static HashMap<String, FAQ> FAQTable;

		// get question by user
		public static FAQ get(String question_uuid) throws SQLException {
			return getAll().get(question_uuid);
		}
		
		// transactions as list
		public static ArrayList<FAQ> getAsList() throws SQLException {
			return new ArrayList<FAQ>(getAll().values());
		}
				
		// updates table from db
		static HashMap<String, FAQ> getAll() throws SQLException {
			loadDatabase();
			if (FAQTable == null) {
				FAQTable = new HashMap<String, FAQ>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from FAQ;");
				while (rs.next()) {
					FAQ f = new FAQ(rs);
					FAQTable.put(f.question_uuid, f);
				}
			}
			return FAQTable;
		}
		
		// create question
		public static void insert(Question q) throws SQLException {
			loadDatabase();
			String query = "INSERT INTO FAQ(question_uuid, admin_uuid, question, answer) VALUES (?, ?, ?, ?);";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, q.question_uuid);
			ps.setString(2, q.admin_uuid);
			ps.setString(3, q.question);
			ps.setString(4, q.answer);
			ps.executeUpdate();
			FAQTable = null;
		}
	}
}