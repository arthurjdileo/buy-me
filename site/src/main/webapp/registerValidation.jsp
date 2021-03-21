<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
String fname = request.getParameter("fname");
String lname = request.getParameter("lname");
String email = request.getParameter("email");
String pwd = request.getParameter("password");
ArrayList<String> errors = new ArrayList<String>();
session.setAttribute("errorsReg", errors);

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
	session.setAttribute("errorsReg", errors);
	response.sendRedirect("register.jsp");
	return;
}

String accountUUID = UUID.randomUUID().toString();
request.getHeader("X-Forwarded-For");
String ipAddr = request.getRemoteAddr();
String hashedPw = BuyMe.Sessions.hashPassword(pwd);
User u = new User(email, hashedPw, accountUUID, fname, lname, 0, ipAddr, 0, 1);

BuyMe.Users.insert(u);

String sessionUUID = BuyMe.genUUID();
Cookie loginCookie = new Cookie("SESSION_UUID", sessionUUID);
loginCookie.setMaxAge(30*60); // 30 mins
response.addCookie(loginCookie);
Session s = new Session(sessionUUID, accountUUID);
BuyMe.Sessions.insert(s);
response.sendRedirect("profile.jsp");
return;
%>