<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
Cookie loginCookie = null;
Cookie[] cookies = request.getCookies();
if (cookies != null) {
	for (Cookie cookie : cookies) {
		if (cookie.getName().equals("SESSION_UUID")) {
			loginCookie = cookie;
			break;
		}
	}
}
if (loginCookie != null) {
	loginCookie.setMaxAge(0);
	response.addCookie(loginCookie);
	BuyMe.Sessions.remove(loginCookie.getValue());
}
response.sendRedirect("login.jsp");
return;
%>