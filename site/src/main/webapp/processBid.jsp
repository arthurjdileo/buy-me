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
	
	double bidAmount = Double.parseDouble(request.getParameter("bidAmt"));
	String listingUUID = request.getParameter("listingUUID");
	Listing l = BuyMe.Listings.get(listingUUID);
	Bid topBid = BuyMe.Bids.topBid(l);
	if ((topBid != null && bidAmount < topBid.amount) || bidAmount < l.start_price) {
		errors.add("Invalid bid amount.");
		response.sendRedirect("listing-item.jsp?listingUUID=" + listingUUID);
		return;
	}
	if ((topBid != null && bidAmount - topBid.amount < l.bid_increment) || bidAmount - l.start_price < l.bid_increment) {
		errors.add("Bid must be greater than or equal to $" + l.bid_increment);
		response.sendRedirect("listing-item.jsp?listingUUID=" + listingUUID);
		return;
	}
	
	if (u.credits < bidAmount) {
		errors.add("You do not have enough funds. Balance: $" + u.credits);
		response.sendRedirect("listing-item.jsp?listingUUID=" + listingUUID);
		return;
	}
	
	String bidUUID = BuyMe.genUUID();
	
	Bid b = new Bid(bidUUID, u.account_uuid, listingUUID, bidAmount);
	
	BuyMe.Bids.insert(b);
	BuyMe.Users.updateCredits(u, u.credits-bidAmount);
	
	if (BuyMe.Listings.checkWin(l)) {
		response.sendRedirect("listing-item.jsp?sold=1&listingUUID=" + listingUUID);
		return;
	}
	
	response.sendRedirect("listing-item.jsp?listingUUID=" + listingUUID);
%>