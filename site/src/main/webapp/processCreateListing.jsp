<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	Cookie[] cookies = request.getCookies();
	User u = BuyMe.Sessions.getBySession(BuyMe.Sessions.getCurrentSession(cookies));


	String product = request.getParameter("product");
	int category = Integer.parseInt(request.getParameter("category"));
	int subCategory = Integer.parseInt(request.getParameter("sub-category"));
	String description = request.getParameter("description");
	int numDays = Integer.parseInt(request.getParameter("num-days"));
	String imgURL = request.getParameter("image-link");
	double startPrice = Double.parseDouble(request.getParameter("price"));
	double reservePrice = -1;
	if (request.getParameter("reserve-price") != "") {
		reservePrice = Double.parseDouble(request.getParameter("reserve-price"));
	}
	double bidIncrement = Double.parseDouble(request.getParameter("bid-increment"));
	String currency = request.getParameter("currency");

	Calendar c = Calendar.getInstance();
	c.add(Calendar.DATE, numDays);
	java.sql.Timestamp endDate = new java.sql.Timestamp(c.getTimeInMillis());

	
	String listingUUID = BuyMe.genUUID();
	Listing l = new Listing(listingUUID, u.account_uuid, category,
			subCategory, description, product, imgURL, numDays,
			currency, startPrice, reservePrice,
			0, endDate, bidIncrement, 1);
	BuyMe.Listings.insert(l);
	
	// redirect to listings page
	response.sendRedirect("index.jsp");
%>