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
	ArrayList<String> errors = new ArrayList<String>();
	session.setAttribute("errorsBid", errors);
	
	String listing_uuid = request.getParameter("listingUUID");
	double upper_limit = Double.parseDouble(request.getParameter("max-number"));
	double increment = Double.parseDouble(request.getParameter("bid-number"));
	
	if (BuyMe.AutomaticBids.exists(listing_uuid, u.account_uuid) != null) {
		errors.add("You already have an automatic bid set.");
		response.sendRedirect("listing-item.jsp?listingUUID=" + listing_uuid);
		return;
	}
	
	if (upper_limit > u.credits) {
		errors.add("You do not have enough credits to create an automatic bid!");
		response.sendRedirect("listing-item.jsp?listingUUID=" + listing_uuid);
		return;
	}
	
	AutomaticBid b = new AutomaticBid(u.account_uuid, listing_uuid, upper_limit, increment);
	BuyMe.AutomaticBids.insert(b);
	SetAlert userAlert = BuyMe.SetAlerts.exists(u.account_uuid, "bid", listing_uuid);
	if (userAlert == null) {
		SetAlert a = new SetAlert(BuyMe.genUUID(), u.account_uuid, "bid", listing_uuid);
		BuyMe.SetAlerts.insert(a);
	} else if (userAlert != null && userAlert.is_active == 0) {
		BuyMe.SetAlerts.setActive(userAlert);
	}
	response.sendRedirect("listing-item.jsp?listingUUID=" + listing_uuid);
%>