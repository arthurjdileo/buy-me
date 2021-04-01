<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.util.concurrent.TimeUnit.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	Cookie[] cookies = request.getCookies();
	if (!BuyMe.Sessions.safetyCheck(cookies)) {
		response.sendRedirect("login.jsp");
		return;
	}
	User u = BuyMe.Sessions.getBySession(BuyMe.Sessions.getCurrentSession(cookies));
	
	String fromAdmin = request.getParameter("from-admin");
	
	String listingUUID = request.getParameter("listingUUID");
	Listing l = BuyMe.Listings.get(listingUUID);
	if (!l.seller_uuid.equals(u.account_uuid) && !BuyMe.Admins.isAdmin(u.account_uuid) && !BuyMe.Admins.isMod(u.account_uuid)) {
		response.sendRedirect("index.jsp");
		return;
	}
	
	BuyMe.Listings.remove(listingUUID);
	if (fromAdmin != null && fromAdmin.equalsIgnoreCase("true")) {
		response.sendRedirect("admin.jsp");
	} else {
		response.sendRedirect("profile.jsp");
	}
	return;
%>