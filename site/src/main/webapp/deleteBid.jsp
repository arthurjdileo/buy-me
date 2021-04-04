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
	if(!BuyMe.Admins.isAdmin(u.account_uuid) && !BuyMe.Admins.isMod(u.account_uuid)) {
		response.sendRedirect("index.jsp");
		return;
	}
		
	String bidUUID = request.getParameter("bidUUID");
	String listingUUID = request.getParameter("listingUUID");
	Listing l = BuyMe.Listings.get(listingUUID);
	BuyMe.Bids.remove(bidUUID);
	Event e = new Event(u.account_uuid, "Deleted Listing: '" + l.item_name + "'");
	BuyMe.Events.insert(e);
	response.sendRedirect("listing-item.jsp?listingUUID=" + listingUUID);
	return;
%>