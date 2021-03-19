<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
    
<%
	String email = request.getParameter("email");
	String pwd = request.getParameter("password");
	ArrayList<String> errors = new ArrayList<String>();
	session.setAttribute("errors", errors);
	
	
	
	for (User u : BuyMe.Users.getAsList()) {
		if (u.email.equalsIgnoreCase(email)) {
			if (u.password.equals(pwd)) {
				String sessionUUID = UUID.randomUUID().toString();
				Cookie loginCookie = new Cookie("SESSION_UUID", sessionUUID);
				loginCookie.setMaxAge(10);
				response.addCookie(loginCookie);
				Session s = new Session(sessionUUID, u.account_uuid);
				BuyMe.Sessions.insert(s);
				response.sendRedirect("index.jsp");
				return;
			} else {
				errors.add("Incorrect password for " + u.email);
				response.sendRedirect("login.jsp");
				return;
			}
		}
	}
	errors.add("No account found for " + email);
	session.setAttribute("email", email);
	response.sendRedirect("login.jsp");
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