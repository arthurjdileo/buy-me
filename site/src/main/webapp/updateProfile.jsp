<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	Cookie[] cookies = request.getCookies();
	if (!BuyMe.Sessions.safetyCheck(cookies)) {
		response.sendRedirect("login.jsp");
		return;
	}
	User u = BuyMe.Sessions.getBySession(BuyMe.Sessions.getCurrentSession(cookies));

	String firstName = request.getParameter("first-name");
	String lastName = request.getParameter("last-name");
	String email = request.getParameter("email");
	String pwd = request.getParameter("password");
	String confirmPw = request.getParameter("change-password");
	ArrayList<String> errors = new ArrayList<String>();
	session.setAttribute("errorUpdateProfile", errors);
	
	if (!pwd.equals(confirmPw)) {
		errors.add("Passwords are not matching");
		response.sendRedirect("profile.jsp");
		return;
	} else if (pwd.length() < 8 || pwd == null) {
		errors.add("Password must be at least 8 characters.");
		response.sendRedirect("profile.jsp");
	}
	if (firstName.equals("")) {
		firstName = u.firstName;
	}
	if (lastName.equals("")) {
		lastName = u.lastName;
	}
	if (email.equals("")) {
		email = u.email;
	}
	if (pwd.equals("") || confirmPw.equals("")) {
		pwd = u.password;
	}
	
	String hashedPw = BuyMe.Sessions.hashPassword(pwd);
	User updated = new User(email, hashedPw, u.account_uuid, firstName, lastName, u.credits, u.lastIP, u.pwReset, u.isActive);
	BuyMe.Users.update(updated);
	response.sendRedirect("profile.jsp");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>