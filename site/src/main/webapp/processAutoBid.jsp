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
	int edit = 0;
	if (request.getParameter("edit") != null && request.getParameter("edit").equalsIgnoreCase("true")) {
		edit = 1;
	}
	
	if (BuyMe.AutomaticBids.exists(listing_uuid, u.account_uuid) != null && edit == 0) {
		edit = 1;
	}
	
	if (upper_limit > u.credits) {
		errors.add("You do not have enough credits to create an automatic bid!");
		response.sendRedirect("listing-item.jsp?listingUUID=" + listing_uuid);
		return;
	}
	
	Bid topBid = BuyMe.Bids.topBid(BuyMe.Listings.get(listing_uuid));
	boolean bidPlaced = false;
	Bid newBid = null;
	if (!topBid.buyer_uuid.equals(u.account_uuid)) {
		newBid = new Bid(BuyMe.genUUID(), u.account_uuid, listing_uuid, BuyMe.Listings.getCurrentPrice(BuyMe.Listings.get(listing_uuid)) + increment);
		BuyMe.Bids.insert(newBid);
		bidPlaced = true;
	}
	
	AutomaticBid b = new AutomaticBid(u.account_uuid, listing_uuid, upper_limit, increment);
	if (edit == 0) {
		BuyMe.AutomaticBids.insert(b);
	} else {
		BuyMe.AutomaticBids.update(b);
	}
	
	if (bidPlaced && newBid != null) {
		BuyMe.SetAlerts.bidProcess(listing_uuid, newBid);
	}
	
	BuyMe.AutomaticBids.process(listing_uuid);
	SetAlert userAlert = BuyMe.SetAlerts.exists(u.account_uuid, "bid", listing_uuid);
	if (userAlert == null) {
		SetAlert a = new SetAlert(BuyMe.genUUID(), u.account_uuid, "bid", listing_uuid);
		BuyMe.SetAlerts.insert(a);
	} else if (userAlert != null && userAlert.is_active == 0) {
		BuyMe.SetAlerts.setActive(userAlert);
	}
	response.sendRedirect("listing-item.jsp?listingUUID=" + listing_uuid);
%>