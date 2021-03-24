package me.arthurdileo;

import java.util.*;

import javax.servlet.http.Cookie;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
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
		
		// update user
		public static void update(User u) throws SQLException {
			loadDatabase();
			String query = "UPDATE Users SET f_name = ?, l_name = ?, email = ?, pw = ? WHERE acc_uuid = ?;";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, u.firstName);
			ps.setString(2, u.lastName);
			ps.setString(3, u.email);
			ps.setString(4, u.password);
			ps.setString(5, u.account_uuid);
			ps.executeUpdate();
			UserTable = null;
		}
		
		public static void updateCredits(User u, double credits) throws SQLException {
			loadDatabase();
			String query = "UPDATE Users SET credits = ? WHERE acc_uuid = ?;";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setDouble(1, credits);
			ps.setString(2, u.account_uuid);
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
			ArrayList<Listing> active = new ArrayList<Listing>();
			for (Listing l : getAll().values()) {
				if (l.is_active == 1) {
					active.add(l);
				}
			}
			return active;
		}
		
		// inactive listings
		public static ArrayList<Listing> getInActiveAsList() throws SQLException {
			ArrayList<Listing> inactive = new ArrayList<Listing>();
			for (Listing l : getAll().values()) {
				if (l.is_active == 0) {
					inactive.add(l);
				}
			}
			return inactive;
		}
				
		// updates table from db
		static HashMap<String, Listing> getAll() throws SQLException {
			loadDatabase();
			if (ListingsTable == null) {
				ListingsTable = new HashMap<String, Listing>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from Listing;");
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
			String query = "INSERT INTO Listing(listing_uuid, seller_uuid, cat_id, sub_id, item_name, description, image, listing_days, currency, start_price, reserve_price, num_bids, bid_increment, end_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE cat_id = ?, sub_id = ?, item_name = ?, description = ?, image = ?, listing_days = ?, currency = ?, start_price = ?, reserve_price = ?, bid_increment = ?, end_time = ?;";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, l.listing_uuid);
			ps.setString(2, l.seller_uuid);
			ps.setInt(3, l.cat_id);
			ps.setInt(4, l.sub_id);
			ps.setString(5, l.item_name);
			ps.setString(6, l.description);
			ps.setString(7, l.image);
			ps.setInt(8, l.listing_days);
			ps.setString(9, l.currency);
			ps.setDouble(10, l.start_price);
			if (l.reserve_price == -1) {
				ps.setNull(11, Types.NULL);
			} else {
				ps.setDouble(11, l.reserve_price);
			}
			ps.setInt(12, l.num_bids);
			ps.setDouble(13, l.bid_increment);
			ps.setTimestamp(14, l.end_time);
			ps.setInt(15, l.cat_id);
			ps.setInt(16, l.sub_id);
			ps.setString(17, l.item_name);
			ps.setString(18, l.description);
			ps.setString(19, l.image);
			ps.setInt(20, l.listing_days);
			ps.setString(21, l.currency);
			ps.setDouble(22, l.start_price);
			ps.setDouble(23, l.reserve_price);
			ps.setDouble(24, l.bid_increment);
			ps.setTimestamp(25, l.end_time);
			ps.executeUpdate();
			ListingsTable = null;
		}
		
		// remove listing from db
		public static void remove(String listing_uuid) throws SQLException {
			loadDatabase();
			String query = "UPDATE Listing SET is_active = 0 WHERE listing_uuid = ?;";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, listing_uuid);
			ps.executeUpdate();
			ListingsTable = null;
		}
		
		public static ArrayList<Listing> getByUser(String account_uuid) throws SQLException {
			ArrayList<Listing> listings = getAsList();
			ArrayList<Listing> filtered = new ArrayList<Listing>();
			
			for (Listing l : listings) {
				if (l.seller_uuid.equals(account_uuid)) {
					filtered.add(l);
				}
			}
			return filtered;
		}
		
		public static ArrayList<Listing> searchByName(String query) throws SQLException {
			ArrayList<Listing> listings = getAsList();
			ArrayList<Listing> searchResults = new ArrayList<Listing>();
			String[] split = query.split(" ");
			
			for (Listing l : listings) {
				for (String s : split) {
					if (l.item_name.toLowerCase().contains(s.toLowerCase()) && !searchResults.contains(l)) {
						searchResults.add(l);
					}
				}
			}
			return searchResults;
		}
		
		public static ArrayList<Listing> getByCategory(int id) throws SQLException {
			ArrayList<Listing> listings = getAsList();
			ArrayList<Listing> filtered = new ArrayList<Listing>();
			
			for (Listing l : listings) {
				if (l.cat_id == id) {
					filtered.add(l);
				}
			}
			return filtered;
		}
		
		public static ArrayList<Listing> getBySubCategory(int id) throws SQLException {
			ArrayList<Listing> listings = getAsList();
			ArrayList<Listing> filtered = new ArrayList<Listing>();
			
			for (Listing l : listings) {
				if (l.sub_id == id) {
					filtered.add(l);
				}
			}
			return filtered;
		}
		
		public static ArrayList<Listing> searchByCategory(String query) throws SQLException {
			ArrayList<Category> categories = BuyMe.Categories.getAsList();
			ArrayList<SubCategory> subCategories = BuyMe.SubCategories.getAsList();
			ArrayList<Listing> searchResults = new ArrayList<Listing>();
			String[] split = query.split(" ");
			
			for (Category c : categories) {
				for (String s : split) {
					if (c.name.toLowerCase().contains(s.toLowerCase())) {
						for (Listing l : getByCategory(c.id)) {
							if (!searchResults.contains(l)) {
								searchResults.add(l);
							}
						}
					}
				}
			}
			for (SubCategory c : subCategories) {
				for (String s : split) {
					if (c.name.toLowerCase().contains(s.toLowerCase())) {
						for (Listing l : getBySubCategory(c.id)) {
							if (!searchResults.contains(l)) {
								searchResults.add(l);
							}
						}
					}
				}
			}
			return searchResults;
		}
		
		public static ArrayList<Listing> searchByUser(String query) throws SQLException {
			ArrayList<Listing> listings = getAsList();
			ArrayList<Listing> searchResults = new ArrayList<Listing>();
			String[] split = query.split(" ");
			
			for (Listing l : listings) {
				User seller = BuyMe.Users.get(l.seller_uuid);
				for (String s : split) {
					s = s.toLowerCase();
					if (seller.firstName.toLowerCase().contains(s) || seller.lastName.toLowerCase().contains(s)) {
						for (Listing u : getByUser(seller.account_uuid)) {
							searchResults.add(u);
						}
					}
				}
			}
			return searchResults;
		}
		
		public static double getCurrentPrice(Listing l) throws SQLException {
			Bid topBid = BuyMe.Bids.topBid(l);
			return topBid != null ? topBid.amount : l.start_price;
		}
		
		public static double getMinBidPrice(Listing l) throws SQLException {
			return getCurrentPrice(l) + l.bid_increment;
		}
		
		public static boolean checkWin(Listing l) throws SQLException {
			User winner = getWinnerReserve(l);
			if (winner != null) {
				remove(l.listing_uuid);
				Transaction t = new Transaction(winner.account_uuid, l.seller_uuid, l.listing_uuid, BuyMe.Bids.topBid(l).amount);
				BuyMe.TransactionHistory.insert(t);
				return true;
				// set alert
			}
			return false;
		}
		
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
		public static Bid get(String bid_uuid) throws SQLException {
			return getAll().get(bid_uuid);
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
				ResultSet rs = st.executeQuery("select * from Bid;");
				while (rs.next()) {
					Bid b = new Bid(rs);
					BidsTable.put(b.bid_uuid, b);
				}
			}
			return BidsTable;
		}
		
		// create a new bid
		public static void insert(Bid b) throws SQLException {
			loadDatabase();
//			check for errors
			// create transaction
			String query = "INSERT INTO Bid(bid_uuid, buyer_uuid, listing_uuid, amount) VALUES (?, ?, ?, ?);";
			String query2 = "UPDATE Listing SET num_bids = num_bids + 1 WHERE listing_uuid = ?;";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, b.bid_uuid);
			ps.setString(2, b.buyer_uuid);
			ps.setString(3, b.listing_uuid);
			ps.setDouble(4, b.amount);
			ps.executeUpdate();
			PreparedStatement ps2 = conn.prepareStatement(query2);
			ps2.setString(1, b.listing_uuid);
			ps2.executeUpdate();
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
		
		// get all bids for listing
			public static ArrayList<User> getBiddersByListing(String listing_uuid) throws SQLException {
				ArrayList<Bid> bids = getAsList();
				ArrayList<User> bidders = new ArrayList<User>();
				
				for (Bid b : bids) {
					if (b.listing_uuid.equals(listing_uuid) && !bidders.contains(BuyMe.Users.get(b.buyer_uuid))) {
						bidders.add(BuyMe.Users.get(b.buyer_uuid));
					}
				}
				return bidders;
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
		
		public static ArrayList<Bid> getBidsByUserForListing(String account_uuid, String listing_uuid) throws SQLException {
			ArrayList<Bid> userBids = getBidsByUser(account_uuid);
			ArrayList<Bid> userBidsForListing = new ArrayList<Bid>();
			for (Bid b : userBids) {
				if (b.listing_uuid.equals(listing_uuid)) {
					userBidsForListing.add(b);
				}
			}
			return userBidsForListing;
		}
		
		public static ArrayList<Bid> sort(ArrayList<Bid> bids) {
			Collections.sort(bids);
			return bids;
		}
		
		public static String format(Bid b, String pattern) {
			LocalDateTime dt = b.created.toLocalDateTime();
			return dt.atZone(ZoneOffset.UTC).format(DateTimeFormatter.ofPattern(pattern).withZone(ZoneId.of("America/New_York")));
		}
		
		// get top bid by listing
		public static Bid topBid(Listing l) throws SQLException {
			ArrayList<Bid> bids = Bids.getBidsByListing(l.listing_uuid);
			
			double maxBid = 0;
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
			ps.setDouble(4, t.amount);
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
	
	public static class Admins {
		static HashMap<String, Admin> AdminsTable;
		
		// get admin by acc_uuid
		public static Admin get(String account_uuid) throws SQLException {
			return getAll().get(account_uuid);
		}
		
		// admins as list
		public static ArrayList<Admin> getAsList() throws SQLException {
			return new ArrayList<Admin>(getAll().values());
		}
		
		// updates table from db
		static HashMap<String, Admin> getAll() throws SQLException {
			loadDatabase();
			if (AdminsTable == null) {
				AdminsTable = new HashMap<String, Admin>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from Admins;");
				while (rs.next()) {
					Admin a = new Admin(rs);
					AdminsTable.put(a.acc_uuid, a);
				}
			}
			return AdminsTable;
		}
		
		// check if user is admin
		public static boolean isAdmin(String account_uuid) throws SQLException {
			loadDatabase();
			for (Admin a : getAsList()) {
				if (a.acc_uuid.equals(account_uuid)) {
					return true;
				}
			}
			return false;
		}
		
		// get role
		public static String getRole(String account_uuid) throws SQLException {
			loadDatabase();
			for (Admin a : getAsList()) {
				if (a.acc_uuid.equals(account_uuid)) {
					return a.role;
				}
			}
			return null;
		}
	}
	
	public static class Categories {
		static ArrayList<Category> CategoryTable;
		
		// categories as list
		public static ArrayList<Category> getAsList() throws SQLException {
			return new ArrayList<Category>(getAll());
		}
		
		// updates table from db
		static ArrayList<Category> getAll() throws SQLException {
			loadDatabase();
			if (CategoryTable == null) {
				CategoryTable = new ArrayList<Category>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from Category;");
				while (rs.next()) {
					Category c = new Category(rs);
					CategoryTable.add(c);
				}
			}
			return CategoryTable;
		}
		
		public static Category getByName(String name) throws SQLException {
			ArrayList<Category> categories = getAsList();
			
			for (Category c : categories) {
				if (c.name.equalsIgnoreCase(name)) {
					return c;
				}
			}
			return null;
		}
		
		public static Category getByID(int id) throws SQLException {
			ArrayList<Category> categories = getAsList();
			
			for (Category c : categories) {
				if (c.id == id) {
					return c;
				}
			}
			return null;
		}
	}
	
	public static class SubCategories {
		static ArrayList<SubCategory> SubCategoriesTable;
		
		// categories as list
		public static ArrayList<SubCategory> getAsList() throws SQLException {
			return new ArrayList<SubCategory>(getAll());
		}
		
		// updates table from db
		static ArrayList<SubCategory> getAll() throws SQLException {
			loadDatabase();
			if (SubCategoriesTable == null) {
				SubCategoriesTable = new ArrayList<SubCategory>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from SubCategory;");
				while (rs.next()) {
					SubCategory c = new SubCategory(rs);
					SubCategoriesTable.add(c);
				}
			}
			return SubCategoriesTable;
		}
		
		public static ArrayList<SubCategory> getByCategory(int cat_id) throws SQLException {
			ArrayList<SubCategory> subCategories = getAsList();
			ArrayList<SubCategory> filtered = new ArrayList<SubCategory>();
			
			for (SubCategory c : subCategories) {
				if (c.cat_id == cat_id) {
					filtered.add(c);
				}
			}
			return filtered;
		}
		
		public static SubCategory getByID(int id) throws SQLException {
			ArrayList<SubCategory> subCategories = getAsList();
			
			for (SubCategory c : subCategories) {
				if (c.id == id) {
					return c;
				}
			}
			return null;
		}
	}
	
	public static class AutomaticBids {
		static ArrayList<AutomaticBid> AutomaticBidTable;
		
		// categories as list
		public static ArrayList<AutomaticBid> getAsList() throws SQLException {
			return new ArrayList<AutomaticBid>(getAll());
		}
		
		// updates table from db
		static ArrayList<AutomaticBid> getAll() throws SQLException {
			loadDatabase();
			if (AutomaticBidTable == null) {
				AutomaticBidTable = new ArrayList<AutomaticBid>();
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery("select * from AutomaticBid;");
				while (rs.next()) {
					AutomaticBid b = new AutomaticBid(rs);
					AutomaticBidTable.add(b);
				}
			}
			return AutomaticBidTable;
		}
		
		public static void insert(AutomaticBid b) throws SQLException {
			loadDatabase();
			String query = "INSERT INTO AutomaticBid(buyer_uuid, listing_uuid, upper_limit, increment) VALUES (?, ?, ?, ?);";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, b.buyer_uuid);
			ps.setString(2, b.listing_uuid);
			ps.setDouble(3, b.upper_limit);
			ps.setDouble(4, b.increment);
			ps.executeUpdate();
			AutomaticBidTable = null;
		}
		
		public static ArrayList<AutomaticBid> getByListing(String listing_uuid) throws SQLException {
			ArrayList<AutomaticBid> bids = getAsList();
			ArrayList<AutomaticBid> listingBids = new ArrayList<>();
			for (AutomaticBid b : bids) {
				if (b.listing_uuid.equals(listing_uuid)) {
					listingBids.add(b);
				}
			}
			return listingBids;
		}
		
		public static AutomaticBid exists(String listing_uuid, String buyer_uuid) throws SQLException {
			ArrayList<AutomaticBid> bids = getAsList();
			
			for (AutomaticBid b : bids) {
				if (b.listing_uuid.equals(listing_uuid) && b.buyer_uuid.equals(buyer_uuid)) {
					return b;
				}
			}
			return null;
		}
		
		public static void process(String listing_uuid) throws SQLException {
			ArrayList<AutomaticBid> autoBids = getByListing(listing_uuid);
			
			for (AutomaticBid b : autoBids) {
				Bid topBid = BuyMe.Bids.topBid(BuyMe.Listings.get(b.listing_uuid));
				ArrayList<Bid> userBids = BuyMe.Bids.getBidsByUserForListing(b.buyer_uuid, listing_uuid);
				double userMax;
				if (userBids.size() == 0) {
					userMax = 0;
				} else {
					userMax = Collections.max(userBids).amount;
				}
				double bidAmt = BuyMe.Listings.getCurrentPrice(BuyMe.Listings.get(listing_uuid)) + b.increment;
				if (topBid.amount > userMax && bidAmt <= b.upper_limit && !topBid.buyer_uuid.equals(b.buyer_uuid) && bidAmt <= BuyMe.Users.get(b.buyer_uuid).credits) {
					String bidUUID = BuyMe.genUUID();
					Bid newBid = new Bid(bidUUID, b.buyer_uuid, b.listing_uuid, bidAmt);
					
					BuyMe.Bids.insert(newBid);
					if (BuyMe.Listings.checkWin(BuyMe.Listings.get(b.listing_uuid))) {
						BuyMe.Users.updateCredits(BuyMe.Users.get(b.buyer_uuid), BuyMe.Users.get(b.buyer_uuid).credits-bidAmt);
					}
				}
			}
		}
	}
	
	public static class Alerts {
		static ArrayList<Alert> AlertsTable;
		
		
	}
}