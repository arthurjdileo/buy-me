<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
String fname = request.getParameter("fname");
String lname = request.getParameter("lname");
String email = request.getParameter("email");
String pwd = request.getParameter("password");
String confirm = request.getParameter("confirm-password");
String fromAdmin = request.getParameter("from-admin");
ArrayList<String> errors = new ArrayList<String>();
if (fromAdmin != null) {
	session.setAttribute("errorsRegAdmin", errors);
} else {
	session.setAttribute("errorsReg", errors);
}

if (!pwd.equals(confirm)) {
	errors.add("Your passwords do not match.");
}

if (pwd.length() < 8 || pwd == null) {
	errors.add("Password must be at least 8 characters.");
}

ArrayList<User> users = BuyMe.Users.getAsList();

for (User u : users) {
	if (u.email.equalsIgnoreCase(email)) {
		errors.add("The email " + email + "already has an account.");
	}
}

if (errors.size() > 0) {
	System.out.println(errors);
	if (fromAdmin != null) {
		session.setAttribute("errorsRegAdmin", errors);
		response.sendRedirect("admin.jsp");
	} else {
		session.setAttribute("errorsReg", errors);
		response.sendRedirect("register.jsp");
	}
	return;
}

String accountUUID = BuyMe.genUUID();
request.getHeader("X-Forwarded-For");
String ipAddr = request.getRemoteAddr();
String hashedPw = BuyMe.Sessions.hashPassword(pwd);
User u = new User(email, hashedPw, accountUUID, fname, lname, 50000, ipAddr, 1);
BuyMe.Users.insert(u);

if (fromAdmin == null) {
	String sessionUUID = BuyMe.genUUID();
	Cookie loginCookie = new Cookie("SESSION_UUID", sessionUUID);
	loginCookie.setMaxAge(30*60); // 30 mins
	response.addCookie(loginCookie);
	Session s = new Session(sessionUUID, accountUUID);
	BuyMe.Sessions.insert(s);
}

if (fromAdmin != null) {
	String isMod = request.getParameter("isMod");
	if (isMod != null && isMod.equalsIgnoreCase("true")) {
		BuyMe.Admins.setRole(accountUUID, "Moderator");
	}
	
	Event e = new Event(u.account_uuid, "Created account: '" + email + "'");
	BuyMe.Events.insert(e);
}

if (fromAdmin != null) response.sendRedirect("admin.jsp");
else response.sendRedirect("index.jsp");
return;
%>